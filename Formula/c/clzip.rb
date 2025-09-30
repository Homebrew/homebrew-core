class Clzip < Formula
  desc "C language version of lzip"
  homepage "https://www.nongnu.org/lzip/clzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/clzip/clzip-1.15.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/clzip/clzip-1.15.tar.gz"
  sha256 "287e8515268ff8d16244878e0e2e2d733c03d92dd2b2b84915d75ef4de6c261f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/clzip/"
    regex(/href=.*?clzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bd7da69d8efd7a71e3ac572bcd83ce05f1f4ef26a19a171c30490f3ebc7d917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5296e7aa0bef00a127b4838e95fc81a0a5aafa526979dcbf798d95ed06131075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1162da004f92fdba81258c665f2dad66f1a892a4bc2603cd4f92f1c111df8c75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27ab76d3e0409fbbd117d0b4c5d71ee222c065c2b6b909e1d68b15d88ce69a5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a87893c127e69f726be285c873af960f1ac01f252b91e64ab6d3c2fa8b01240"
    sha256 cellar: :any_skip_relocation, ventura:       "e953203c1637aca538d76ebf6ceb376df49300d304a08bb911ee73735e34d50e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "418e07ff6dd8397ddc3ccbea8cffc1a28b6d99f9905c4044b950c95695d208b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9efa76a36107aacb246f72c688c5154bf86b4898ea6e8e3a9c97dc7d93ac157a"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    pkgshare.install "testsuite"
  end

  test do
    cp_r pkgshare/"testsuite", testpath
    cd "testsuite" do
      ln_s bin/"clzip", "clzip"
      system "./check.sh"
    end
  end
end
