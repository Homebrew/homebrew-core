class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15c1f728206dae8fc41add8b930d68ae3cf10992dd7b500ff724adb38fec719d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76b4fe47ef81cca19203f6a5cb13402a0fad41bdbb01bfd92e6ef0ed1d21b971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b9146904a3368fd1940ad0fb30812618f0e21e690cab07382339801f9ed42e8"
    sha256 cellar: :any_skip_relocation, monterey:       "20d0d8c361b1c2cfd9528b914c48208e9965310cd03142b5ee2a34a77621f7ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "55e0c1fa48285daa885761491159fa1fd2c470b28321d0ac490a1a9521e192ff"
    sha256 cellar: :any_skip_relocation, catalina:       "08d80b272677de4e6c0aea32f83d5fde416967fefbccafab0739d8f7935baf35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add3c75896f8c6a0294a5fbddf48584dd94b55b621d9d836d724ced46d8735a7"
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
