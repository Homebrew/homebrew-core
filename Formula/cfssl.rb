class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/1.3.0.tar.gz"
  sha256 "78322f0f37b5c90d612ce4e18b35c03bfde242d32426ef0db1f859255a778384"
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "63d459c5dbab11db35201147e693bcfd58d07d84472eb96707e16cc22bff5390" => :high_sierra
    sha256 "67cb256669f5ec7f4da86cd5e26811e9a8b133dd92d328f93a8669c5bbeb34ff" => :sierra
    sha256 "791df9ea295daa23bd061e7ebb8673f2570f7d2dc90d5b8e32fd20aa07e92277" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "libtool" => :run

  def install
    ENV["GOPATH"] = buildpath
    cfsslpath = buildpath/"src/github.com/cloudflare/cfssl"
    cfsslpath.install Dir["{*,.git}"]
    cd "src/github.com/cloudflare/cfssl" do
      system "go", "build", "-o", "#{bin}/cfssl", "cmd/cfssl/cfssl.go"
      system "go", "build", "-o", "#{bin}/cfssljson", "cmd/cfssljson/cfssljson.go"
      system "go", "build", "-o", "#{bin}/cfsslmkbundle", "cmd/mkbundle/mkbundle.go"
    end
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
