class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.4.1.tar.gz"
  sha256 "c8a86ef10cbb0c168f3b597db15b31f98b170edb7958f7154edeb29aee41315e"
  head "https://github.com/cloudflare/cfssl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bc608472f62d2956917b3f4a8677c64e688cb4e44e7373518c0f4dad6fa17c1" => :catalina
    sha256 "c1e9f1cabe5584928c186fe9221d3565414cf1c04404d040dbc573b38cc3f4fc" => :mojave
    sha256 "441739623fcb7ae9f1efc43541b9bb5268f12cbfd27005b86cfe24c8e2f7966c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "libtool"

  def install
    ENV["GOPATH"] = buildpath
    cfsslpath = buildpath/"src/github.com/cloudflare/cfssl"
    cfsslpath.install Dir["{*,.git}"]
    ldflags = "-X github.com/cloudflare/cfssl/cli/version.version=#{version}"
    cd "src/github.com/cloudflare/cfssl" do
      system "go", "build", "-o", "#{bin}/cfssl", "-ldflags", ldflags, "cmd/cfssl/cfssl.go"
      system "go", "build", "-o", "#{bin}/cfssljson", "-ldflags", ldflags, "cmd/cfssljson/cfssljson.go"
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
