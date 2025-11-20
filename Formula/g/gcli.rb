class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "5f48c3f016c1ef92c53b319ebdf751e66d5757070fc9ae678bedb185a450d426"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2344c39c56ddf3570ce15be918336c0be109d61daf94e976be567c148ea68ab1"
    sha256 cellar: :any,                 arm64_sequoia: "d6199150cd0606278d0704d86eef9ba6086ed1c4c8ebfaad6fce0780964e527a"
    sha256 cellar: :any,                 arm64_sonoma:  "de591e52de72fadee5bf0451001752004a203416bdc4fa8330d11b61af2901fc"
    sha256 cellar: :any,                 sonoma:        "708969b7ca1882adc2368caff7cb540eb035cf72dc8aa49a9c391d1eeff15cb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fa5f424991939f335b5e5ac511db43a540ba63c8edd2bfb60e86228143ea863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e1cffcc03eece2cc7f7240a6d5140b081d5021a85489a82bf6facab0a50b1a"
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
