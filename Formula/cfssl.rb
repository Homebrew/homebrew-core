class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.6.0.tar.gz"
  sha256 "9694e84b42bf3fc547fa5ac5b15099da28129b9b274b3aad3534d7145ca1cc04"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "637f4d77e1d9504dd8c8bc9e9e3635191de063898630b2b17fa84dfb27c6294f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2626630c57a40160555ae195b187284a6ea65bfeca30a0506ac24fe4764f77f"
    sha256 cellar: :any_skip_relocation, catalina:      "06b89c2bb37493bf060d0632cc3d30d7b82ee1c432af8b7a6d22d144afddaf05"
    sha256 cellar: :any_skip_relocation, mojave:        "12c889e31ea954b04e73a764e6879d0993a533de5daabcbdf6a6d995d9531289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed6a9422bc3f93102b8b91422e2a6d384c0c820b3379ac23a26874902aa0848"
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
