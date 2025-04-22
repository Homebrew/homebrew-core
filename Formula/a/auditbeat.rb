class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.0",
      revision: "42a721c925857c0d1f4160c977eb5f188e46d425"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a74bcf6f20d285116a77bf21fe2e559ebe6166887ae5b3e4d186d52d1a09e31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c38c3546444daaf80023d85ae559416844dd2c67cdd6a3350f6cd8375075c3f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1df3196283a8783344bd28af8f3b6a4c8111e3a13ca4b074172e248a87ea2b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddc55f7a00228dae3982a4141e1c70154df500d7d422c574fdbe5fececf8112"
    sha256 cellar: :any_skip_relocation, ventura:       "2e2870b266caf1cc54b69035d4b192ca0ae717561dee3b8ad3ea3f12bbd41cbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f92f77bd7315d9d6423ebb52492fd4c0c14594dcb5a9a5ee9150abf1dfce564c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c90b07c6ed2b0afa1d2302d00954ad754b17d00e188be41ab30d18b9bd9379"
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
