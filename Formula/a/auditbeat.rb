class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.4",
      revision: "10b198c985eb95c16405b979c63847881a199aba"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c74c49b360ceac95f10cd332942441fdb022cf67e1fe6483187dafb053be953"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5c1d670d90b90a31ec7ef62be6e045530a48bd22838adbf9e744ac1f05ed005"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7780b3bbf8bf16197012b15404399e6499db08880d9a2113eb0249d2f910d3b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "11c2c66e1cd3c23a60a3a6c805d9ca46f1472e8bd9edcdeecac8ccfbcea2d896"
    sha256 cellar: :any_skip_relocation, ventura:        "da34b9ed4093509832cdf58cf122714e550fd546f3b12e4d68843ec77d5c31ed"
    sha256 cellar: :any_skip_relocation, monterey:       "ede7cb329a9ba608eac7c5d82fa22887b5591c51cff63880b6e40f11057317f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd52da0416170d9c2e8b8f51143ee7e0820540947c1d074140350e01a3fd09e"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    EOS

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
    (testpath/"config/auditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    EOS
    fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5
    touch testpath/"files/touch"

    sleep 30

    assert_predicate testpath/"data/beat.db", :exist?

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  end
end
