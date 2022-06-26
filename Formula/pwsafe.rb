class Pwsafe < Formula
  desc "Generate passwords and manage encrypted password databases"
  homepage "https://github.com/nsd20463/pwsafe"
  url "https://src.fedoraproject.org/repo/pkgs/pwsafe/pwsafe-0.2.0.tar.gz/4bb36538a2772ecbf1a542bc7d4746c0/pwsafe-0.2.0.tar.gz"
  sha256 "61e91dc5114fe014a49afabd574eda5ff49b36c81a6d492c03fcb10ba6af47b7"
  license "GPL-2.0"
  revision 4

  livecheck do
    url "https://src.fedoraproject.org/repo/pkgs/pwsafe/"
    regex(/href=.*?pwsafe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cb5377b3ac24b40fcdc24660caef85d16af615e4b17c7f18729b7ed84bfe5708"
    sha256 cellar: :any,                 arm64_big_sur:  "a275c6ed6882cc4d69656ce9b779be2ac3cec24a53e2e6a32668f78681a99ec3"
    sha256 cellar: :any,                 monterey:       "f11ebb686f3af73a247dafdbb2ea299ecbf4ee913e668c23d5b233447daa1dd0"
    sha256 cellar: :any,                 big_sur:        "69517fc542457fad58bbebe4e2f60c8316de47f5e50ac546370dc40afc62c5e6"
    sha256 cellar: :any,                 catalina:       "5f952aa85147c86d2f77f9054fe228484820388c3b1e92c39c12432a15ca0f54"
    sha256 cellar: :any,                 mojave:         "94c4b9684c2709c7cbd168609db33271ede431f1f72c348bb508e65a07bf8faa"
    sha256 cellar: :any,                 high_sierra:    "5d5a277678e752596a342712e46dd2e1ce015d6897ad7f74437509a39f47b5ce"
    sha256 cellar: :any,                 sierra:         "e5fd7f0c41f73c0bdf2f455b7ad659d27931afc1e78536e11a0553be0e8cade1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c3ced398e2ae04a1449deb1bf23b033a9d82a44d00d1d7da788ce04f81fde1"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  # A password database for testing is provided upstream. How nice!
  resource "test-pwsafe-db" do
    url "https://raw.githubusercontent.com/nsd20463/pwsafe/208de3a94339df36b6e9cd8aeb7e0be0a67fd3d7/test.dat"
    sha256 "7ecff955871e6e58e55e0794d21dfdea44a962ff5925c2cd0683875667fbcc79"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    test_db_passphrase = "abc"
    test_account_name = "testing"
    test_account_pass = "sg1rIWHL?WTOV=d#q~DmxiQq%_j-$f__U7EU"

    resource("test-pwsafe-db").stage do
      Utils.popen(
        "#{bin}/pwsafe -f test.dat -p #{test_account_name}", "r+"
      ) do |pipe|
        pipe.puts test_db_passphrase
        assert_match(/^#{Regexp.escape(test_account_pass)}$/, pipe.read)
      end
    end
  end
end
