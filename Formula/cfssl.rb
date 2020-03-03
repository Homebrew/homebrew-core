class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.4.1.tar.gz"
  sha256 "c8a86ef10cbb0c168f3b597db15b31f98b170edb7958f7154edeb29aee41315e"
  revision 1
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e26a083603f36d8ae31b26284f2f4bd477118726645c6f68412f4b00e18eea22" => :catalina
    sha256 "9041675a2cb1d9dcc4112e18e4e3e94789ab65c91702065cc39f374d9b16d287" => :mojave
    sha256 "cbf790046b8df80103a42e3e78da7b0be8941efcb9dd9e61e9742685624eddc1" => :high_sierra
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

  def caveats; <<~EOS
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
