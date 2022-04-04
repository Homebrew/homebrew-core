class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/v2.0.1.tar.gz"
  sha256 "65177673e535a5bc0ac05801d2a02bd0cae609ae1e8223e9fe33979404670bf6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "684183cf0ee8b759dc0cdeda4a1cf62ce715422b446e204b189e8419d0841224"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f766f400d42527adaca881a2e10a02677126e29e8004a7cb7c63343d6335b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "13f1a476d7ab6d9143ab3286a4789cbd59c708038e9aee274424b417a1449abe"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3b4827433c0ee693da6251e53efb34bd271c6fe35c3f3b27f25aa413eefad91"
    sha256 cellar: :any_skip_relocation, catalina:       "62024a4f84cd638b0cb6bf795332cbe53faafff0f311805941e5d65c95aa9ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81eba06c4a0d8ab38a58753f8848c9b0e9a8eab281ff2362aa13fe030ca18ea8"
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
