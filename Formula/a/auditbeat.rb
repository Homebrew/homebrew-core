class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.2",
      revision: "480bccf4f0423099bb2c0e672a44c54ecd7a805e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15b43a20d2c02b65348c80bba9f49dc6eaaa7f28dd41669c6a134418a985b860"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f323dce15b9f90617a11dfb41749862064966ec34655a3f413824048137feba1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92805fb5377ad714dd213c57a1dff911eeda9536db78dfa24498d937f91b9fd7"
    sha256 cellar: :any_skip_relocation, ventura:        "1c9493f286fe774ea00e3ef04e22973eda069f524c762f9029e840d44d6719b9"
    sha256 cellar: :any_skip_relocation, monterey:       "82a72017b22be0b5253208d73f775a20d4f4e1b516b49a798cb50a940100bc0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d753ab93bd09d30eafd8a5c732edb19fa940fcd390b4fb23d88d4fd608b2dab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bafe15c5671530818f1d9f3dbb5306bf76ea258a6c5725c59c5235efc472494f"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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
