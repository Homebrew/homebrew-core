class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/1.2.0.tar.gz"
  sha256 "28e1d1ec6862eb926336490e2fcd1de626113d3e227293a4138fec59b7b6e443"
  revision 2

  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b53506ab12658b30195f8bbd09b72c51e4d730a35cd303cb2b8c344e1aaa2830" => :el_capitan
    sha256 "cbd93af7c030d90139ad751d417a14a2255dae413a92d9270fdd4c93782ce066" => :yosemite
    sha256 "8e5346797e6b452e40e2e5434406c20d2a2dc8a411b8916268a6624c8cbe340d" => :mavericks
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

  def caveats; <<-EOS.undent
    `mkbundle` has been installed as `cfsslmkbundle` to avoid conflict
    with Mono and other tools that ship the same executable.
  EOS
  end

  test do
    require "utils/json"
    (testpath/"request.json").write <<-EOS.undent
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
    response = Utils::JSON.load(File.read(testpath/"response.json"))
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, response["cert"])
    assert_match(/.*-----END CERTIFICATE-----$/, response["cert"])
    assert_match(/^-----BEGIN RSA PRIVATE KEY-----.*/, response["key"])
    assert_match(/.*-----END RSA PRIVATE KEY-----$/, response["key"])
  end
end
