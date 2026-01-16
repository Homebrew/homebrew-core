class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.11/dateutils-0.4.11.tar.xz"
  sha256 "b8fea0b09714bbadf202b9b3434cce6b59c282e7869268d0c08b85880fdbb446"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "90799580c0526cfb486b63cfe21575a026d74bd84bb056f7a8a711375adbc8f5"
    sha256 arm64_sequoia:  "bbfe40e57ba5e294c140bde89dd3d4de4bc40d2c00a791a4a644c0f41b95327e"
    sha256 arm64_sonoma:   "c75426bef62674c457efcf5fcdd60503ea93af78ab5f6de87482368f7242027a"
    sha256 arm64_ventura:  "bba65693686a7f03b0955fa474f749452689f33c12c6ce824d107c7af109b1d5"
    sha256 arm64_monterey: "e486bf17d2170960a1759478948e5512e0b1ae7a56f7050900d51689d461bc1b"
    sha256 sonoma:         "9942401d4ccb1dfccbefab2d8f07d1bb6c087eef8fe499fa2878e736f4783f51"
    sha256 ventura:        "4a175bd0dd49c33c55b6b70f90e5f52541a3af70f6e289247f919e882f191b66"
    sha256 monterey:       "96425fd7ec4be82236ab3dc31532b1a15dcde6fea5ba84b23a1ddb8e98f2c659"
    sha256 arm64_linux:    "f3e8c09d527d268d8b5155c4c7f2fcb918b85370a3c0fc5a6b4cba84dfb614b1"
    sha256 x86_64_linux:   "9660d3c687240196d8b0f0bd9b33a085f5af1e09dc1452fbc25e712a3735637a"
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-07", output
  end
end
