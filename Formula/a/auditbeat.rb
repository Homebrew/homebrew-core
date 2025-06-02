class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.1",
      revision: "bce373f7dcd56a5575ad2c0ec40159722607e801"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d822de8cab572027463209e5fa78238501386683c3fef621a3f84bf4535b2df2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "632ea9d9e45e8b94d2e9bb56716ff4c0c7556c920c191e99af7ed3b5bf2c5b45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff998cef6bcd82f473ddfc79b2ecfe0c73c7a841b177f15b41ed368cd835ed4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f67d3d9d871489609b2f8898be9dd35cb69030940995a4a4faac220148d5b14"
    sha256 cellar: :any_skip_relocation, ventura:       "d9be3f87a36dc42bb8b3b615df5b3b96bd20e54f5f41d5e0fdfd85e11fdc8b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1803b42e30d15f205f37ff90ba4004defff329cf33374f31bd3961427783704f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8dc9fb21a382e4032a633b67dc405b6728372af46afdaea80e1b0b5798f9e1"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~SHELL
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    SHELL

    chmod 0555, bin/"auditbeat"
    generate_completions_from_executable(bin/"auditbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  service do
    run opt_bin/"auditbeat"
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~YAML
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    YAML

    pid = spawn bin/"auditbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"
    sleep 5
    touch testpath/"files/touch"
    sleep 10
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"data/beat.db"

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
