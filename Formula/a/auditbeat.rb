class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.12.1",
      revision: "c7ec8f634ed6052674762b32fa640087d32f165f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1a172681c1ee600b1c8c033cd9abbf4cef1965beb20c134e428790c7272f236"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3fd46069336fd3c5cf6a9ce7af323125555016416383de6d5d62522eff3ae52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79d726b3184811a18e2119dc8e017e447c71cdf871bd190c72009e2b99077763"
    sha256 cellar: :any_skip_relocation, sonoma:         "38516eda5f0cd702b6437bc3a923cfd04418a95ef3063872c0b1c17f897f87c7"
    sha256 cellar: :any_skip_relocation, ventura:        "1ddd78be21c3d98f44efc36383a85319941d08e1bf2017cb9e30ccdb3c3e9103"
    sha256 cellar: :any_skip_relocation, monterey:       "b10443b2544f044d82d45770bade76c317233d014e1f08be6ec5a2ee04419834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c1169fca0f4a37eddd2059e4953fa020da99f26fa0d441f0f8ffedfc7454e0"
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
