class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://github.com/grom358/hqx"
  url "https://github.com/grom358/hqx.git",
      tag:      "v1.2",
      revision: "124c9399fa136fb0f743417ca27dfa2ca2860c2d"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "5ba31ed02cebc80553587975d7e1ea4085b44268a69b51d354049e245ab9b541"
    sha256 cellar: :any,                 arm64_sequoia: "26d37d607203ed3b98a2d4c95179d450618364a40b47f1b786d62490d4089f6a"
    sha256 cellar: :any,                 arm64_sonoma:  "096c40b5ec2a465a94ce4a00fd757898991dd427cc94be3c1e362417d75e9acb"
    sha256 cellar: :any,                 sonoma:        "d6fbbc9e2d37a51909096d28fe0da09e1c50841e26067aae8742e6d046a063e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a81a59b54a05fba307d89d73008552a4a486b09695952a22f2db0c7270c0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55439a7262c1a955fb22b374b737a614b63279a535828cf4c7ad10d31ab085c9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "php" => :test
  depends_on "devil"

  def install
    ENV.deparallelize
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"hqx", test_fixtures("test.jpg"), "out.jpg"
    output = pipe_output("php -r \"print_r(getimagesize('file://#{testpath}/out.jpg'));\"")
    assert_equal <<~EOS, output
      Array
      (
          [0] => 4
          [1] => 4
          [2] => 2
          [3] => width="4" height="4"
          [bits] => 8
          [channels] => 3
          [mime] => image/jpeg
          [width_unit] => px
          [height_unit] => px
      )
    EOS
  end
end
