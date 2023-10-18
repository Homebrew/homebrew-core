class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.6.4.tar.gz"
  sha256 "652b8c50882035e7dc13e937729c84217259838ba80ce089048b96795389482e"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18d0ae4ac84d1aac8c6c51d61fa360b8ae2849405264c9456ad376fdd02d3cfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13eec81639a2f2b7410d7bbc82b8eee6f5d154c97dfeece7556e464a7d350ecb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "509d715fcb6c46394d74e4475f9755656b4dc129251d81f9f18658f994af3b0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21d5f13dabd1641e6c1507da0b5c55930595e51f6bc89d28dc64dc43f9efe113"
    sha256 cellar: :any_skip_relocation, sonoma:         "004813fea2c556228bd4bf251e021edeeed7967ac04983b9421c1aa40aa35460"
    sha256 cellar: :any_skip_relocation, ventura:        "d121eae6acb5ac4ee9b2f931d20ff534904931de37a239f0eea67e5e5d919a55"
    sha256 cellar: :any_skip_relocation, monterey:       "b14fd6d83726ae06b3062b682055b174fe31c73c0983a9e2a040f063aaea46a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c388e257623007107d6b5ffe192c759e1a03055eb632357b90cf1c2b32669f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38ce3de9fbc732613b2825b7c01106fb566a236afce1d1ee4855f341146e8339"
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
