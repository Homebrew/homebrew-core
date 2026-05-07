class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "ed6c618d9c67fedfca0fb4da79d8a0d9d27efdd82cc74b372d6fe5cd483d6456"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e05a791fe9cf499457c23029ac3a9d9f031cc2a80b87561b31008bf11cd8df45"
    sha256 cellar: :any,                 arm64_sequoia: "cf656dd08da280b4d8b8a0da86cd47476ca0c79e3478f33c561c0de0bc682e4c"
    sha256 cellar: :any,                 arm64_sonoma:  "5d1745ace7de107455d120b4c8b13e62b1e2207618efbe539e11da12b4306892"
    sha256 cellar: :any,                 sonoma:        "3c9e9a1fe14bda6520b85e216f5e3c903158bfe634a685bb1d4f429000189886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94bbd3a0c4e44ae7dad685fcdbdb5670c438ba39abde3e35455130cd05658c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27fc85b30a7717d207a60e475c8a4181b6c9ccff970baa160988cfd91a965c62"
  end

  depends_on "pkgconf" => :build
  depends_on "readline" => :build
  depends_on "lowdown"
  depends_on "openssl@4"

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
