class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b58210a3e705eb2393fb11d555125450e1f0757646a149d61e34094d9cc62f0b"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1b49daa90e02db33ef857896799ed2ffd09061301de975645e526845348ed71c"
    sha256 cellar: :any, arm64_sequoia: "b158e4f5529ffcd3b1c9f3670d67cc4e1d1cb17fe5f29d13611a87dfab1e5bd3"
    sha256 cellar: :any, arm64_sonoma:  "5ba06459dbf8999f7497a11ac35d6becae221244d6127dbe4388943941495119"
    sha256 cellar: :any, sonoma:        "28e6d120ae38225791ec4b696a5a2b80f4ac0a3e617902bc00a758efa3146db5"
    sha256 cellar: :any, arm64_linux:   "cd7aac586687058f3d462180c73fb9cc4967682f5674c978a4070cf4989b3c68"
    sha256 cellar: :any, x86_64_linux:  "276f57900cf180d02338b542ebc8b27da3cb799537899d486602ec37b38253f8"
  end

  depends_on "pkgconf" => :build
  depends_on "readline" => :build
  depends_on "lowdown"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"

  def install
    # Do not use `*std_configure_args`, `./configure` script throws errors if unknown flag is passed
    system "./configure", "--prefix=#{prefix}", "--release"
    system "make", "install"
  end

  test do
    assert_match "gcli: error: no account specified or no default account configured",
      shell_output("#{bin}/gcli -t github repos 2>&1", 1)
    assert_match(/FORK\s+VISBLTY\s+DATE\s+FULLNAME/,
      shell_output("#{bin}/gcli -t github repos -o linus"))
  end
end
