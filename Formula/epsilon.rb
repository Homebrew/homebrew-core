class Epsilon < Formula
  desc "Powerful wavelet image compressor"
  homepage "https://epsilon-project.sourceforge.io"
  url "https://downloads.sourceforge.net/project/epsilon-project/epsilon/0.9.2/epsilon-0.9.2.tar.gz"
  sha256 "5421a15969d4d7af0ac0a11d519ba8d1d2147dc28d8c062bf0c52f3a0d4c54c4"
  license all_of: [
    "BSD-3-Clause",
    any_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/epsilon[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "547069ed37303eb1cd4e8757cc595338852617040c9eadb2493aca79ca014571"
    sha256 cellar: :any,                 arm64_monterey: "670034faf15b3c9d8aee0684969850959349bfe460dac4df70dd7b379a6103f2"
    sha256 cellar: :any,                 arm64_big_sur:  "38532cb4e33c6bb1da6f76c3e218c141ccf6888a56200807d05358d64a6709c7"
    sha256 cellar: :any,                 ventura:        "633feb4f0326003a7b01cb1c4879a334ce2f8872a008382ad9a8ea9110e04d2e"
    sha256 cellar: :any,                 monterey:       "85c792185e97c4bf15321c4947d284df6f8246d84c007a28d0f2ae269d37ba79"
    sha256 cellar: :any,                 big_sur:        "86724d0787346a00a324bc0204d7b141b43cee6969069351747626354f80507d"
    sha256 cellar: :any,                 catalina:       "62d1ce5e34b79a09f68f079ec79768e85677ab5d6f3c13caedae9bd41399e052"
    sha256 cellar: :any,                 mojave:         "102517b4fb6cb9eccc86a50b774424748805bf14f2d2cc53f08e558f43c3f602"
    sha256 cellar: :any,                 high_sierra:    "87935305d8659e6cdcde272d469768c48dd870f227ab894aa71a6b206be5fa1f"
    sha256 cellar: :any,                 sierra:         "a8aee2fb802a82cdbf701003195285f20f1b067ceec72d6e3170e3a69032a0e8"
    sha256 cellar: :any,                 el_capitan:     "10da057d558d4d9df8c503135b53f7c23778258f7c66d3b39229bf70d9a887f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d74732822ae5b53c57fc5bc613e70de84daca229438e47739c875f6dc50b21b1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "popt"

  def install
    # None of our patches apply, so regenerate `configure` to fix the `-flat_namespace` bug.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/epsilon", "--version"
  end
end
