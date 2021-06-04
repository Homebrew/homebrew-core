class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.5.0.tar.gz"
  sha256 "5267164b18aa99a844e05adceaf4f62d1b96dcd326a9132098d65c515c180a91"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "871db96ebb99fe15d2fa4879ede55acc81c6412b421969435e298c4b56de6bd7"
    sha256 cellar: :any_skip_relocation, big_sur:       "5461bace7b3ba595fca81cd7d2bacb35fe349e1915d04dcfcb18c47e2e6d7c77"
    sha256 cellar: :any_skip_relocation, catalina:      "8da797d63b4ee6f985b0bf1e2b4a44a08fcc4d5c1c4266fca178891c40cec83a"
    sha256 cellar: :any_skip_relocation, mojave:        "9a0553b89f1058f0ede9aef4667fa1527e230a27c0d6e26af01f0b63c9f71409"
  end

  depends_on "go" => :build
  depends_on "libtool"

  def install
    ldflags = "-s -w -X github.com/cloudflare/cfssl/cli/version.version=#{version}"

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", "#{bin}/cfssl", "cmd/cfssl/cfssl.go"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", "#{bin}/cfssljson", "cmd/cfssljson/cfssljson.go"
    system "go", "build", "-o", "#{bin}/cfsslmkbundle", "cmd/mkbundle/mkbundle.go"
  end

  def caveats
    <<~EOS
      `mkbundle` has been installed as `cfsslmkbundle` to avoid conflict
      with Mono and other tools that ship the same executable.
    EOS
  end

  test do
    (testpath/"request.json").write <<~EOS
      {
        "CN" : "Your Certificate Authority",
        "hosts" : [],
        "key" : {
          "algo" : "rsa",
          "size" : 4096
        },
        "names" : [
          {
            "C" : "US",
            "ST" : "Your State",
            "L" : "Your City",
            "O" : "Your Organization",
            "OU" : "Your Certificate Authority"
          }
        ]
      }
    EOS
    shell_output("#{bin}/cfssl genkey -initca request.json > response.json")
    response = JSON.parse(File.read(testpath/"response.json"))
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, response["cert"])
    assert_match(/.*-----END CERTIFICATE-----$/, response["cert"])
    assert_match(/^-----BEGIN RSA PRIVATE KEY-----.*/, response["key"])
    assert_match(/.*-----END RSA PRIVATE KEY-----$/, response["key"])

    assert_match(/^Version:\s+#{version}/, shell_output("#{bin}/cfssl version"))
  end
end
