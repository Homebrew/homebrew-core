class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/1.3.4.tar.gz"
  sha256 "ca120300f5bf3b2f8da229d10d4b2882a87075861541608bd07cd68238cef86c"
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba9571999266074d81e6bb4f217d3c45fcb94527487eeb5ace75792b7ed199ea" => :mojave
    sha256 "38dbabe5a39ed3227794967c278ae276093129d447185649fe61367bc8f82d17" => :high_sierra
    sha256 "910309082f62cf08117212ba3906aaad66f459b792dc0420322ad6b6e2bbe195" => :sierra
  end

  depends_on "go" => :build
  depends_on "libtool"

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
