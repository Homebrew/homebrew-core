class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "573b9aad0a185b243a548c54db6c60e6f762489d12acd81968d7eda58ce5a089"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "881e2a5d663be19141ac9af399dee4170c37a3163e57639e04f71786c632e36a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "014f515eeea3e23ebffef3667c0b47fdda9532c6c2167d43d269d06f17346032"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9ee240b237fe78753cfa21f22ed5a7e9fa22819a237b45fe0e638dad4f19384"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d5aecb5e6662e9c65fb14ff25d98981958f9fb623a53361093c6f83ebcd1436"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc02ef0b12d67fe423c0d6a9b2aaf7016999493df91007aed64adab474edff8"
    sha256 cellar: :any_skip_relocation, monterey:       "552b059720a1e0e00f49a8aa15759694a4978a12a2255a2f6b41cce023cd8f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07182826d840b79ac3163bc7c6dc776eadd083641292f7b921692de705c898bb"
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
