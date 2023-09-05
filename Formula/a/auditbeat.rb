class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.1",
      revision: "3799398872c0f33da4e65019390d055cdfe633bd"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f40fde6b7d68d58b405591befb1a4697889cb8bdbdcde8e764fe80f8b16db0ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bc47faf49d5e7b88559ab15cf2f70c0271c73d6802fd97f1c2b7f143c4457bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e77964ac02ccfce203d38785996537873ae01158300054775666e410a49a479f"
    sha256 cellar: :any_skip_relocation, ventura:        "85e046b7c305ed4c67ae1c9d544667e0e973a4cfb22a9ef86f9d386ed37cd15d"
    sha256 cellar: :any_skip_relocation, monterey:       "ba188b3f3897ac105d8cad2fdf9e59c5a9d8d558591fe81e3d29aa418be353a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "899dae328607460a23ca46ee35b607722b153553e42c4dd31cb505ebf424e91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ad09b7c0a3d2b4d6955b42f3e1ee48dfcab6169bbf2ac3ca1400204ffa2fc1"
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
