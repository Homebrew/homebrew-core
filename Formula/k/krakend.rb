class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "7dae53c65e46fea0bfea04d2c48f3fd0ada29d8ba94a7d97fccf4632bd067859"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5e9504308ab6a66b2076ad0a98dc247132c460af21d25f899e24afab7332866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e54c08be7e967c1cfa79ae1c1c0f58c9bf2eeff837b237b4cfa9dc53c99a67ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6076f63b9d36baeaec5fabcf47890f71433b11e013bfe95560c15bbad3731d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4663bd621d5eb1f61aacf45f286742d45dd7cecdea04bda27b7a119ae69093a3"
    sha256 cellar: :any_skip_relocation, ventura:       "56d5cb44c1bb08393cfdd31b3073df7a5f390cf8c0dbc3fe5dae27d10d624c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5132790c24c6cdf5f3d221e71b15eabc6fe1e7d632d09b8d0e6f8a60bb1a97dd"
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
