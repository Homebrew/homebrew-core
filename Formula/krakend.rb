class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "021fdd994c802762fd13980898e971d02238eefb4ed14a729e1565c64f5b2cd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f013cacff828384a967de03020fe0cbea5e63bbc858ca18ac06f234d63a2cd1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5093eda48238920893dc5b615885923d03a8faa1eb62628bea173de86f090658"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc38466f72fb7f736acc09d99da4a04efc8215325c63c0e5aa5ee4331c1d9fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "695a5f47b675eecfd9aba82f1b3b85c3029fda0888b5ac6178e418211eeff721"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3be434848aec89d9946a42c452cff5776e73959401bed6668542e92403f633"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b996c26c924d027b365b8564ab10c91263ee9a18f22190fb1673aaaaec52e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814fa6e59bfe30c27563f4cfc91a6f254b5c5592d7ccab5ac6deb14fc48a1213"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "krakend"
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
