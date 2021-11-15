class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.2",
      revision: "fd322dad6ceafec40c84df4d2a0694ea357d16cc"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5727d724640485ea32d8c8fc5741a4d9fd519afe536e72cddf289913e1e3cf96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1eb8afd453072ccecd6e6294ee32faf4739077830683d61bccfdd95fecb85cd"
    sha256 cellar: :any_skip_relocation, monterey:       "2302951195e3b591328531fd3128423d77b7bcfe9badfe2509d376b04d36356e"
    sha256 cellar: :any_skip_relocation, big_sur:        "331d5b22e19c4cf32aa5a1263710eae6b7175985c9d7eb7bbad0575e945a0cba"
    sha256 cellar: :any_skip_relocation, catalina:       "8c14e815146473ad881bef101695072ce0e86d4ae4f57c67912cb7ab06127e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58642f164829ceea762d24ec458b16dc810180b72afb4ae4448306d11fc69835"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.9" => :build

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
    s = File.readlines(testpath/"auditbeat/auditbeat").last(1)[0]
    assert_match(/"action":\["(initial_scan|created)"\]/, s)
    realdirpath = File.realdirpath(testpath)
    assert_match "\"path\":\"#{realdirpath}/files/touch\"", s
  end
end
