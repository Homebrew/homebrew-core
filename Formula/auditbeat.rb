class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.3",
      revision: "7826dc5e91c6e6d2487e05d3a8298f49041cd5c2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acc00ec990560a395ef9bb4a53bf96dc73436eb6539c3105891c9bb06c011d1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7736ac5ed7d0bc2f5f50725b099f128ff1a13d6d82d05ef9bd49a24f7d461fc1"
    sha256 cellar: :any_skip_relocation, monterey:       "fa10781b5a2e6e8e0b849bc04a1657de703d02ffcd4e2a3fc5cad7e88d5b856e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d3851ff3faf4667dad0755756a0bd095bab7ba8452a0fb4821e536500fc66b"
    sha256 cellar: :any_skip_relocation, catalina:       "4bd95b330d898817f53af9d994b701256b05e6d35f9fe18f5a2b89240df1f318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16c53ab37365f33440b4d2cbdfcecf6373e8bb0dfe0010f8ea95fc92f9bec77"
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
