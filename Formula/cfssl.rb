class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.6.3.tar.gz"
  sha256 "501e44601baabfac0a4f3431ff989b6052ce5b715e0fe4586eaf5e1ecac68ed3"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eec84f1596edabb713888989797d9e5b5dd0ecc7e0294c94633b3f6f825098f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d0e6236486aa126f772d7032ecabdf328fc47868732986d583bbe306fee46f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3017502bbc93892c0745141349353acb3bc9e332fba7877a96a72174c75248b4"
    sha256 cellar: :any_skip_relocation, ventura:        "8bfbfe4d4a3b0780943092c99e1e3118920795f0913c48eee1abb17bd1c4493c"
    sha256 cellar: :any_skip_relocation, monterey:       "9f1fcc16f9eb7529cd885cd00f98ce85b85538c965580e2fd339efb7565c1543"
    sha256 cellar: :any_skip_relocation, big_sur:        "23cdd69e2098cd6fcf2d7bcad7c82d631616d93d2e96cec9f8bede446adc7d6d"
    sha256 cellar: :any_skip_relocation, catalina:       "2c4b8d46567c449c0e728fdb459ac5e0b327e8d5093655d3b5b7eef18f099abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a93664ec06633cd8566a1acdb576c500dc57cf7e47e70e1bc6ab018a964d80"
  end

  depends_on "go" => :build
  depends_on "libtool"

  def install
    ldflags = "-s -w -X github.com/cloudflare/cfssl/cli/version.version=#{version}"

    system "go", "build", *std_go_args(output: bin/"cfssl", ldflags: ldflags), "cmd/cfssl/cfssl.go"
    system "go", "build", *std_go_args(output: bin/"cfssljson", ldflags: ldflags), "cmd/cfssljson/cfssljson.go"
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
