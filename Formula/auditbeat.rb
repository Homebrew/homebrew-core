class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.0",
      revision: "2ab3a7334016f570e0bfc7e9a577a35a22e02df5"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ede19d8efb3cbed5fb838b0e7654b308f8ee83ba11784eeadc1158bc4b58a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc4d8c95612e95d54b035dbb6ab3ca5a601e1e201a249d855f276aa0802462fd"
    sha256 cellar: :any_skip_relocation, monterey:       "cb8c13fbf24644876a720cceb7ee9e94ada2425c9654870714b3c54343cd64a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "edabab5d7e4cf619942f5355f2a60856035d848ebc49a213c202b19d176d2d56"
    sha256 cellar: :any_skip_relocation, catalina:       "27d8cdee010d8f5dc1bbd1388bc3ca3d230bd113057b1fe5ec9bc061967611fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4f1a5b3533ab40ab0f3209c1061dc77f78ccf354281b96b06f9a918ffdf4ddd"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

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
