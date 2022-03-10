class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/v2.0.0.tar.gz"
  sha256 "07ce9669881f13d9c3d1ae2c14de353461a44e7ef2d95a4cf1eb66d915fb59ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66ab126253dca6455754caa44cccc8ce4030df71e96c98f9f2cc9eb183b40846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44688e4b5565386a7fb7802027ddcbd4d0e7234aba5da50bc35b10b567781d90"
    sha256 cellar: :any_skip_relocation, monterey:       "9fe818a27bdd90c98dd43127276c205f2ffa2dc3cbc2f487fe78219e6eb8204c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9741367a11c025db5e35028ca92c47c18d016e55981ff4759e88042aa49d7f52"
    sha256 cellar: :any_skip_relocation, catalina:       "9d105d4c64a7b0ebb809a5bf8e6f93c0d38307453c5acf8ef1da2cdccf1204f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01627ad13e5e16854b672413ad74722026afd6071b8dfb3780ffaf969f82a312"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/devopsfaith/krakend-ce").install buildpath.children
    cd "src/github.com/devopsfaith/krakend-ce" do
      system "make", "build"
      bin.install "krakend"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~EOS
      {
        "version": 2,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        }
      }
    EOS
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 3,
        "bad": file
      }
    EOS
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~EOS
      {
        "version": 3,
        "extra_config": {
          "telemetry/logging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "/test",
            "backend": [
              {
                "url_pattern": "/backend",
                "host": [
                  "http://some-host"
                ]
              }
            ]
          }
        ]
      }
    EOS
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
