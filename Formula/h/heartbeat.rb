class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.3",
      revision: "3747d0eb6c26247477dd62ca51535cff8d6338b7"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db4a3bcbfd8feb7fe9456558189d2a88ee92780e3b460f7ae2acbdf05939eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1617dc568da085a407e4baee5b68fe4e652545b709a1d1ab537a80b3e7f3a8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eddd259ec25374ba17af5b320f332b343ac9cd70e5d2cf6293a7919fcb07fbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e0325f6e7df0b602178819a6654d7840c1877b028d69bf32d7584cb5f1cb808"
    sha256 cellar: :any_skip_relocation, ventura:       "60f51c08d5fc7e88245ce6482aae1d824c9d513f8b6840ea0ee36c7a551a9d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56f41ae7656def174fc1cb2f8ee2d268b5f33507b6d0754eb5c8b6d9af34706b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "heartbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", "(Fields, FieldDocs,", "(Fields,"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["heartbeat.*"], "fields.yml"
      (libexec/"bin").install "heartbeat"
    end

    (bin/"heartbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/heartbeat \
        --path.config #{etc}/heartbeat \
        --path.data #{var}/lib/heartbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/heartbeat \
        "$@"
    EOS

    chmod 0555, bin/"heartbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"heartbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/heartbeat").mkpath
    (var/"log/heartbeat").mkpath
  end

  service do
    run opt_bin/"heartbeat"
  end

  test do
    # FIXME: This keeps stalling CI when tested as a dependent. See, for example,
    # https://github.com/Homebrew/homebrew-core/pull/91712
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    begin
      port = free_port

      (testpath/"config/heartbeat.yml").write <<~YAML
        heartbeat.monitors:
        - type: tcp
          schedule: '@every 5s'
          hosts: ["localhost:#{port}"]
          check.send: "hello\\n"
          check.receive: "goodbye\\n"
        output.file:
          path: "#{testpath}/heartbeat"
          filename: heartbeat
          codec.format:
            string: '%{[monitor]}'
      YAML

      pid = spawn bin/"heartbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)
      sleep 5

      output = JSON.parse((testpath/"data/meta.json").read)
      assert_includes output, "first_start"

      (testpath/"data").glob("heartbeat-*.ndjson") do |file|
        s = JSON.parse(file.read)
        assert_match "up", s["status"]
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
