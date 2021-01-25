class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.5.0.tar.gz"
  sha256 "5267164b18aa99a844e05adceaf4f62d1b96dcd326a9132098d65c515c180a91"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c28baffc2249f7f5ca27dff92318106267840a7ace3237e5de88cdaf30ee758" => :big_sur
    sha256 "fba750edd7173d33b8ae318b9fc4ec45509e3064dcb9f4d81f0dc2b5bd5ad08e" => :arm64_big_sur
    sha256 "eba10fa745e0b84e9ecf812313125f3ce6178b9c4053ba1d5ce81214f34316f7" => :catalina
    sha256 "cb0a2266d3f11b5d4462c824dbc9bbc7f0893bf24f4eb92025809d2ce36f3549" => :mojave
    sha256 "37abc780b685c1aeee3771b5a66771bea66fdb9b49c7aea80d9a0b96a479a10c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "libtool"

  def install
    ldflags = ["-s", "-w",
               "-X github.com/cloudflare/cfssl/cli/version.version=#{version}"]

    system "go", "build", "-o", "#{bin}/cfssl", "-ldflags", ldflags, "cmd/cfssl/cfssl.go"
    system "go", "build", "-o", "#{bin}/cfssljson", "-ldflags", ldflags, "cmd/cfssljson/cfssljson.go"
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
  end
end
