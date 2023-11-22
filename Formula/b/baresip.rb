class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "6d213abe7e285356df91e020f1ace154366ca72d2ea767a324abd87f5a920bcb"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "a8c5d8ba20fff4dbdb26e8ef417a5aafe69a326da485357c736aa62dcfbec490"
    sha256 arm64_ventura:  "51a3571222b9cf1774af61093899284c22a206bb48675603d43a22891f58e55f"
    sha256 arm64_monterey: "57fa921ecee304b9bce8e329fbf05547e727f457e5838db6b6ea6a632541cbf1"
    sha256 sonoma:         "56f3957035c95d4456e281465653ab2cd5a007b7f8fd4949ac607a9109946c1a"
    sha256 ventura:        "a259134833d8a3fa88420067a2055d403a8f0b764b679608bafbef522b975473"
    sha256 monterey:       "c95d6759bb38735e4de999ca1509013c2a59a61b4aadc2e7e854c6cebc840f60"
    sha256 x86_64_linux:   "2244339137291cf40fd22b4f9eac5bdc4068cb63f7bccfccbc4726d61ddd3673"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
