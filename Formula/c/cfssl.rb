class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "6eb828923ad1e43efacab8dde17d86bf05c17ab97c072114a5f17d0184d55a92"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ba1b3c16c901e62e5dc67a8381cd392cae4ba636d0d87530e9f412b0604d558"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01295e3d9baeae7aed07ad69408c00ddb63cd736258fccc44c2caab60e8263db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a2e43753519c987882fe1fc2564a2d5a72de7dbe541634dd25d2e1f8183b742"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9091b726bbc17f36cd81d77748be4dfb5f2f25c6d86e4abd435226e28537d17e"
    sha256 cellar: :any,                 x86_64_linux:      "bdb5c66348316f7460b277dc6ae5643589a639c467687091d90ec6b1e64cf86f"
  end

  depends_on "go" => :build
  depends_on "libtool"

  deny_network_access!

  def install
    ldflags = "-X github.com/cloudflare/cfssl/cli/version.version=#{version}"

    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfssl version")
    assert_match version.to_s, shell_output("#{bin}/cfssljson --version")

    (testpath/"request.json").write <<~JSON
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
    JSON
    response_json = shell_output("#{bin}/cfssl genkey -initca request.json")
    response = JSON.parse(response_json)
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, response["cert"])
    assert_match(/.*-----END CERTIFICATE-----$/, response["cert"])
    assert_match(/^-----BEGIN RSA PRIVATE KEY-----.*/, response["key"])
    assert_match(/.*-----END RSA PRIVATE KEY-----$/, response["key"])
  end
end
