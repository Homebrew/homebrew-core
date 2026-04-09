class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "b682452402f403b6ee668bb042bd9b753fe48df84fa7a18a1c32606ffd4918af"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "601f2a0f658414311595bde5f9ac2c35b557ba0c4d5383fb73a9ae36743be9a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423c61fc2dd3289c74cfd8d2eb4bb30029da5bcaa991c6bcdd4a1bab69b70aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "856a862e8c5986e402c4ffde122f70fd2b9743a2545a18b8a01a237ef023c8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f00e10322e3ca648154246d1f33b622d3043030842d571c320f423f10baa20a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7343337bf340f001683abb5f00711d3d1e504ec77cdac8dd8f1905368fb312a7"
    sha256 cellar: :any_skip_relocation, ventura:       "b4ce95ba0600589a5dd79efd12ab197f688b10ae8c732943b8171520cad39ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74ef31d5f9c24be580f7ca74e48173640cc28a381eba8463bf56c6a0c81d2e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46934407006530d046e2171da9988fdc1cf8cc5e519924d7ba050ee6dee8f0fb"
  end

  depends_on "go" => :build
  depends_on "libtool"

  def install
    ldflags = "-s -w -X github.com/cloudflare/cfssl/cli/version.version=#{version}"

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
