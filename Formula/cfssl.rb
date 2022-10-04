class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.6.3.tar.gz"
  sha256 "501e44601baabfac0a4f3431ff989b6052ce5b715e0fe4586eaf5e1ecac68ed3"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "068525630ea7232521c389d8a10c7e0bd5f1737d46fadb653e332ff776548925"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f9dc8c05d1ea1e5dd8a119fb2b2a1c004ad58256328c24784aff3da4a5d6272"
    sha256 cellar: :any_skip_relocation, monterey:       "6ffea6c0346691064654ae4c71440d049a39107af9783a900ab60dfcb27b6cd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "048d5d0ceab4a3ce85547dd9aba2bc3311255e1c8ce02971801cdd9d2e8d3f4a"
    sha256 cellar: :any_skip_relocation, catalina:       "a1be4cee42490e2fe8b6437db5dd60b9db09df9886cecb2a9bfa8b7bcafefd91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165d15c9de1a2431f96a10b2518df17837dfe578a44a49f8289aa995aa2fb58e"
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
