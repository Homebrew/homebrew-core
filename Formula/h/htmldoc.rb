class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/refs/tags/v1.9.22.tar.gz"
  sha256 "c345bb8d07637765aec699b3f3d703379687c8ea84c9956c8484626a0ac8092c"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "395770fe9fa13483b1d58b5d4fbac5e62b813b27663bc542c6419406916abecb"
    sha256 arm64_sequoia: "b0c98b4352681b91b74def0f85e057019dc2a7b93790cd187e1d53ebfcb8f594"
    sha256 arm64_sonoma:  "d6b43ad11136fb19a1eb5eda6cef473111b6750e7001b2a9b8ea262f1ee1ae5d"
    sha256 sonoma:        "1b340d9d27bdbf7d9b416ba45b5f87997895ffdb358e9f289a45236690adf816"
    sha256 arm64_linux:   "20599abbfe7a4f67d482aa26b987cac45a3664583dd6a7823e0b9ebd2bdb03ea"
    sha256 x86_64_linux:  "1570f66b9c4c6a3fc6913f18a94bb623a5e3b3d30e7187fe5bb67ded08cb46e3"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", "--mandir=#{man}",
                          "--without-gui",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"htmldoc", "--version"
  end
end
