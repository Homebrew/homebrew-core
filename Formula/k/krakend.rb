class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "545e6659769d1116a3deed69d0b0430a3363416036f9dd7358aec9de36cb32bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b3c8516332859bafc41313d6a9fb29122bd27f01f53d3c3bf9e057c80f52a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf700251e98ed9662359aefd8c57066c7e4669794208eb4c5752136eca959a13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6c227ad7976b1b3973b357e4a19b45658a513642dc7302734ce09486c1f76f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2edbd60a3be9f708e2d2c9c02f5a21869276f8048fff4cf6403a21995e0e82e0"
    sha256 cellar: :any_skip_relocation, ventura:        "332079ca1a1b6f606b2e66d366d46a644d2386e3ae6de93ae3dcd1d464dbe3b7"
    sha256 cellar: :any_skip_relocation, monterey:       "c5bb0c273bfcadfaa415198dd8c8287b28fe3621dd640df095fd4cc6f6bb69fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51285d64d53df0839cfabcdc4ec6b79d1f03cbb12b91a86dbf056f24d9a284de"
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
