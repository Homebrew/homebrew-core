class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.4.1.tar.gz"
  sha256 "c8a86ef10cbb0c168f3b597db15b31f98b170edb7958f7154edeb29aee41315e"
  revision 1
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "324cc909a9f6ade935def00160e7031fefa4a6aeb54d7595bec67986015e916b" => :catalina
    sha256 "186357f1d25264be064c11a9aa2f7d7638687b8842a6945f313e576214a0f961" => :mojave
    sha256 "0ad5f71f0350706a43d6fe121ad328c9d9fee4595c51ea900a0b9b466e4909b0" => :high_sierra
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
