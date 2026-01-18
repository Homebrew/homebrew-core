class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "500da41d29fa53ab412a81864624b9e2bcd0785be61234f6cfb6b3b031b83280"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ed8bca5940b303f3f1637ff75a4edd33bf4b7a7261ea6ac078c83ba4265b9f1"
    sha256 cellar: :any,                 arm64_sequoia: "9252a4d927139f16322d9f450d1ec0002c5e39f846b740f5cf93559d5f45d523"
    sha256 cellar: :any,                 arm64_sonoma:  "59a4a1d558e26fa17ff26d3a7f845ae5db2491cab4c653c8a537a413f8f7597d"
    sha256 cellar: :any,                 sonoma:        "bcb8f2c876dc256421965dadabe5f2cce00bf01c5b1a848d9bcdb7e153a325b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070aa65dde3c80d77327ff1589f5042909f5bac2842d3c04a3e5e30eae3de97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766b5e4ee7c4d0bd37d14dc7d07c0f104b4795f595fe4a1456f1d443e4a2f18c"
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
