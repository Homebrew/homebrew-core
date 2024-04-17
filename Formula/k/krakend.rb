class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "587c6f942380e0f6bc6d33593858c1100f235f82660af6b820b8c3e75a41e124"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bcf5caf8ca9134bde784d25009de53b6eb377425fd906c9626f8665125ecef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7645cce302aa2bf643041bf7d2ae8f8fc4b6132eeb0916a38d86927620c19bb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f2cdb730dfcafc5fe5790f137b22f93351fe45de965856a29275279b1781ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a601a1d99360182adc2abd9fe917342a933e93cb678705663ac37676e98cb3e"
    sha256 cellar: :any_skip_relocation, ventura:        "69726a1b9e62f53e299330221c049ad21557cd517171ab451a896b30b08bc429"
    sha256 cellar: :any_skip_relocation, monterey:       "340aea22473e8c54cfc5f27ceb2635d4a79a1f3068ae2255d02b656b16ca67aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb4b75bc85d646c5887da5475ed01e392dea707bb5801a3cbeae3d7da127429e"
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
