class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "325bdc89fa6d11b388cb7436afe7618ca78aa38823b8578721953545b8c5d54b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aa66b9ecaabc8fe1bc75d9f8ca59683062cecb145b1fc3f50bf71d2c843ccc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7263c824ae946fec334ff6fcdf05f14ef3183dc516a76d7b471d10f2928033b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9109111d96b4ef1706fb862fbfdbb2e69ffc31f7652c0ba440eb64a69079c40a"
    sha256 cellar: :any_skip_relocation, ventura:        "9d26f7163053c6c7022b9c5612bfb0b6179fe97b383c54f53441e5fe6e5ecdcd"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd5d94bbf4fa0021c15a293d67e82c49719aba263603a916313737ca74ff0a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b978b3e13c25263b3570052b8605f4ee9d404d9cfa61af0297abc4412fa10f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36216dacc1d7bee1141e242fcfce0014030706e81807ff485b247ef7ae6f2bb8"
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
