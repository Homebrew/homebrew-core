class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "b682452402f403b6ee668bb042bd9b753fe48df84fa7a18a1c32606ffd4918af"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e8989411cf61dac106b1fc275da274f0c07b58c16ce08f0fd194835679f495bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d2805f5ff4362d940159c5578dcf8eb8fdcd102a99f92b6a795c8c47f706967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9b9efc3ba89015abe77d10049ef07445204a054d5e7c18ebed89eb210b137af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6e5105534c9c4c2e3da0319af682127c9f77e63f929e157d59c2e97a946fd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "989ba2b7f104eacbca8168890d255b59918ca2e3247a19aaf721c2835de34b38"
    sha256 cellar: :any_skip_relocation, ventura:        "ec170c030c163a3bee7b0f136fd22f043d93a74917c1acd29d68a5fae228a1fd"
    sha256 cellar: :any_skip_relocation, monterey:       "a25c632a1fe68e2afb9a2ac8cb38fbadf026f2ff15c190a7941d8c02d962d5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde98d987b9a50e4fc9f2fd32a4f85dadcea1bd1b94fa792e0554fae1c183c5b"
  end

  depends_on "go" => :build
  depends_on "libtool"

  def install
    ldflags = "-s -w -X github.com/cloudflare/cfssl/cli/version.version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"cfssl"), "./cmd/cfssl"
    system "go", "build", *std_go_args(ldflags:, output: bin/"cfssljson"), "./cmd/cfssljson"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mkbundle"), "./cmd/mkbundle"
  end

  def caveats
    <<~EOS
      `mkbundle` has been installed as `cfsslmkbundle` to avoid conflict
      with Mono and other tools that ship the same executable.
    EOS
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
    shell_output("#{bin}/cfssl genkey -initca request.json > response.json")
    response = JSON.parse(File.read(testpath/"response.json"))
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, response["cert"])
    assert_match(/.*-----END CERTIFICATE-----$/, response["cert"])
    assert_match(/^-----BEGIN RSA PRIVATE KEY-----.*/, response["key"])
    assert_match(/.*-----END RSA PRIVATE KEY-----$/, response["key"])
  end
end
