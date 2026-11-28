class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "2f11682791c7d86fb24bfe1eb2a074a0a03bb8c7ad544da0daa12e43b747daa8"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    manifest_sha256 "ad934ece1a504656437616bdabc1e62e8b53767d435b0563eb917d8da4efad25"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3228f04fca4e28af5c6cae91a6956a1e80dd8986633e33c972960221b1bdca38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "454146d8ccd8ad3538912fad3bd46ce904928661ce48af223bf32ef8379ea66a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f92102ef032549d333ea5937028f8a4014d1717a75511a1eb4459c92a9557caa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "61824211ef966870b0eec0260180c86ba17d3fd3989c3f745e42322432b771ab"
    sha256 cellar: :any,                 x86_64_linux:      "f66343a19754e0c69da334f3904feb48de242f1984f06f314994fd8bf1945333"
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
