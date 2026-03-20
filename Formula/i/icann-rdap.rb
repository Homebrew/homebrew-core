class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "9854f31c96086cc54110c7d86e7f4c99a37810aab0a9e2b9331d68918c374ede"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34c9b6a21e70a646e7290d1d19486733fae11bdd5aba240ac4923ce1b57427ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "043a2c7f3e5045f65d95d862697992cd6bf708aa49101c849980e6f2623fec8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0699d4673f303f1b4ebc80d82fd1b8b8d5419d91ec98c5f58c7a89b5ae6d7827"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d2d8c72ec6a3ac1fc4d416709b45be42e4791b9299c388b50bc3d17d6ab7d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "598e86e5b1bec87ed8de06c60445d4a18b686c78a6d827bf7cbdfe61cd5b0e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fada26f6ba2ed67ea9caa729f9cdb5e4a75f253cfe3d9ae00addbcf614334a2c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  conflicts_with "rdap", because: "rdap also ships a rdap binary"

  def install
    system "cargo", "install", "--bin=rdap", *std_cargo_args(path: "icann-rdap-cli")
    system "cargo", "install", "--bin=rdap-test", *std_cargo_args(path: "icann-rdap-cli")
  end

  test do
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap -V")
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap-test -V")

    # lookup com TLD at IANA with rdap
    url = "https://rdap.iana.org/domain/com"
    output = shell_output("#{bin}/rdap -O pretty-json #{url}")
    assert_match '"ldhName": "com"', output

    # test com TLD at IANA with rdap-test
    output = shell_output("#{bin}/rdap-test -O pretty-json --skip-v6 -C gtld-profile-error #{url}")
    assert_match '"status_code": 200', output
  end
end
