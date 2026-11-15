class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.98.tar.gz"
  sha256 "e9d4cc0816db95c64d32e79f778836db0f1f7eb15868490bd330104e5146b66e"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?gifsicle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f63c4f62ba3fe4edf1d2a15185e20d33449a97f61e057b4ac701e120d0fc2c18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1967131476c690b30ceb427e62b8815295181dc07e062a93b8febefaf4e227d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "920b2bab19d19c912a9b26adc928934c7fe513c4f6877ea1366fb555308036a2"
    sha256 cellar: :any,                 arm64_linux:       "7a20a7b49085747f88d21c0609efb80fd3b1c0c2c791f11a85b4ab22e2f7e740"
    sha256 cellar: :any,                 x86_64_linux:      "d3b0516e2fee18cd7496d5eb5157f92fee1c1ecd87dbeadd2a675326bdfd7b0e"
  end

  head do
    url "https://github.com/kohler/gifsicle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  deny_network_access!

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
