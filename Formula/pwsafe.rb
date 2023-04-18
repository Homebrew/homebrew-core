class Pwsafe < Formula
  desc "Generate passwords and manage encrypted password databases"
  homepage "https://github.com/nsd20463/pwsafe"
  url "https://src.fedoraproject.org/repo/pkgs/pwsafe/pwsafe-0.2.0.tar.gz/4bb36538a2772ecbf1a542bc7d4746c0/pwsafe-0.2.0.tar.gz"
  sha256 "61e91dc5114fe014a49afabd574eda5ff49b36c81a6d492c03fcb10ba6af47b7"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://src.fedoraproject.org/repo/pkgs/pwsafe/"
    regex(/href=.*?pwsafe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f2f69ecce57634d5a3911badcea213810fb8a25b7b2a242e7f342980760703d3"
    sha256 cellar: :any,                 arm64_monterey: "109f4ad6b786e20de525ce0006c5e6ea0c049c8977c2d82833f41a9dd534721a"
    sha256 cellar: :any,                 arm64_big_sur:  "92fe9319e5412529ea46bbf4813b8cb009636efe05c2b1448ec7a332e4c15df5"
    sha256 cellar: :any,                 ventura:        "f955d487b5a38817af4455dae4f9324e854bc550b1384a6940f7d2b49917eb2a"
    sha256 cellar: :any,                 monterey:       "1c773e828b7a92a8d8da681549a8cc20a9fb2dded715cc82331eb74037a98e26"
    sha256 cellar: :any,                 big_sur:        "e7c3595ff796b678efd8aedd74dcc59e057b3a4b96908c820fae3b643d9d8e45"
    sha256 cellar: :any,                 catalina:       "ceda65b7835ed7e72491565952827cc23c8a56f70dd2f875b269eaa8bcaf4f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dcacc8d3f09ec672a4130e55695240788145e0159f6a606c67912d8411c2c0d"
  end

  head do
    url "https://github.com/nsd20463/pwsafe.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"
  depends_on "readline"

  # A password database for testing is provided upstream. How nice!
  resource "test-pwsafe-db" do
    url "https://raw.githubusercontent.com/nsd20463/pwsafe/208de3a94339df36b6e9cd8aeb7e0be0a67fd3d7/test.dat"
    sha256 "7ecff955871e6e58e55e0794d21dfdea44a962ff5925c2cd0683875667fbcc79"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--without-x"
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
