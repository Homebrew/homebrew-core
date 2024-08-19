class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.15.0",
      revision: "76f45fe41cbd4436fba79c36be495d2e1af08243"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bad2c9de29ccce77b9d42573e6482b132c037c7fbb9c5a29ed4e9843ae444e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5f597c7ed40f2f12df2e653b40fadfd82594d8ca22d7971e94f0ab0060f7dc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48c067b5758e0f60e9cb37e91fc409ea4d51323f63344a2a7dcee6b49942de79"
    sha256 cellar: :any_skip_relocation, sonoma:         "5aeba47f26a5b02a77a0fd8a474e75cfbc18da46da338037f502fa261a4e8a14"
    sha256 cellar: :any_skip_relocation, ventura:        "7ace6ce8f224ab61ded2bbe5f207d21b2669951566428f8d84d4769ee3d8ae2f"
    sha256 cellar: :any_skip_relocation, monterey:       "e93cbb1f8477038375db414346a20492e4a6b9528258a9f0365d04384caf913f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde1f9f127774b75a166ba9c659ca521dd1a6c4e81e71859167b83c92140fe43"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

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
      exec bin/"auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5
    touch testpath/"files/touch"

    sleep 30

    assert_predicate testpath/"data/beat.db", :exist?

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  end
end
