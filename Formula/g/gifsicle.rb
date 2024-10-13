class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.95.tar.gz"
  sha256 "b2711647009fd2a13130f3be160532ed46538e762bfc0f020dea50618a7dc950"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?gifsicle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ba90fe9c8699b146bf0b44d09fcd82de129ecd4b13adbecfdebcfa13f8a80fa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47546a82fae6efc95d68737cfeb31d602d7ad2f33cd2ba2fa35caf8a22d2b3fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77137576a3a3cfc1ce005b89934f59e33bf20129004597dfdd35a986144a25ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef0d504edee2dc94eba412e0d9a9e72a4954deb9286e4d95044d04d62784895"
    sha256 cellar: :any_skip_relocation, sonoma:         "c848a63a7ab4074aa514051301a276c367156b969fcb816abbb76aef8cdc46b3"
    sha256 cellar: :any_skip_relocation, ventura:        "92bce8d736d3c03c8a11ada61cde7beee8b687af98dcaaa26af7f15a17e9770f"
    sha256 cellar: :any_skip_relocation, monterey:       "143c0be0bfb5affecdf96f409c1e879ae7931dc43bbd62ea958bf3c828facc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce49462da5c4afda892a7cea190a59a89f9125b483d2dc19da2088f25e71277"
  end

  head do
    url "https://github.com/kohler/gifsicle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "--info", test_fixtures("test.gif")
  end
end
