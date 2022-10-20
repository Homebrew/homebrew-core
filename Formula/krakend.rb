class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "30bfafb835a8e0fef6fc04a9aaf529cc9cf9b7ba33c03cf0affe8897222c816a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775bcdca42306f51879fc063a2296235c4fc0f14a2bea0e28a66618c57ce18ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad61f927d3be8cef26b94bf6074b357777768f78b8bb97afaa232bbcb5940e38"
    sha256 cellar: :any_skip_relocation, monterey:       "93f5fffef1425983f0bedec0fcfb54d7e374426c3665404350a1ca63948ccbc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d32f42025b7edc72d9e0e38a05e29e593fdce376b75dc1e2d64d85d90c4a92d"
    sha256 cellar: :any_skip_relocation, catalina:       "0a44da8939a3cb0c67b2172e50c4490889afefa5155ebdfb47f7f989bbb5bc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45704c049480bf4aa96376e24ca696cd5ca63cd950caae2311c2c4487ce697d"
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
