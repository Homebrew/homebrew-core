class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.1",
      revision: "c74896ed7acbb92921ee46fa5e3d66d575a8b0a9"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43c4bafd1905ed246fbdc393fbad81fc752140763a6907892af9ef4289edcb81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e614b87009c597f2fe823d161aa94279e147c1730add1bb48e927dbf81e9215"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e6e003e130a35f2e0f6924985b198715edaf85c9bb789db2f0c626cbed4fce"
    sha256 cellar: :any_skip_relocation, sonoma:         "b43e362bb9b0d420f3dde3acaf3266b0db1ae3b6e1a7282e157ee301d94a3ad2"
    sha256 cellar: :any_skip_relocation, ventura:        "86d5aec9873351f82aecf9101cf4a9f07347eb115ca386ebbf6cc78942d4ebf2"
    sha256 cellar: :any_skip_relocation, monterey:       "0a32968c90eada5f4be79480f0867861d43d532613a481651832410492f58884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1a9b3ee107fe918b0e19fc94cfc4543c482a91a195bae99a0f78c0269a7a663"
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
