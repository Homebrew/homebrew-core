class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/krakendio/krakend-ce/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "0a3a51cf8f309cb6798e8be1885c312e38dfd5d30e0e62ebc967a2875d816296"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff7541ffe4a6b8bfd66bc5813f18886d8cde74ba8494ec64eec82fe1838de75f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42530680192e2c40819954380502d7086cb8fa8dd5b57f294f2abb674c190b02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "988775616e9e45b55431ea01c33c9d30a9ced3a19f4c28c7aafd48b7e75a8d34"
    sha256 cellar: :any_skip_relocation, ventura:        "ccd80c0e4dde059b51fa2610de71c8f0d841b5ddfb3942753f5d5b32a8da7639"
    sha256 cellar: :any_skip_relocation, monterey:       "88bcfbccaf7606b24e0e34add15555a4787f9c6d1176f871450c3af7cd451aa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f55fbfe74ae0d8b51988dfa8824f1988c7979695cfdef416b406c7fd374b8f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a158a65134872ea4a981724ac47445519ad4ee9dee7b7ae0c6bcf9fa55996759"
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
