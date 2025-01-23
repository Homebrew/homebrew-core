class Icu4cAT75 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-75-1/icu4c-75_1-src.tgz"
  version "75.1"
  sha256 "cb968df3e4d2e87e8b11c49a5d01c787bd13b9545280fc6642f826527618caef"
  license "ICU"
  revision 1

  livecheck do
    url :stable
    regex(/^release[._-]v?(75(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f07c25ad9219c64a89315c92926a4ed100abee56ca8239697f4d4ed96fc8c4e"
    sha256 cellar: :any,                 arm64_sonoma:  "992749cb6ae752008a3ae031fdc6972833f7ccece25557990797abedb65cdc34"
    sha256 cellar: :any,                 arm64_ventura: "bc6e3f3b55834a9d8ed02b27160c5fad0fc51083d3d75a5241ac7fb6396ac2d0"
    sha256 cellar: :any,                 sonoma:        "db53be7588fef20af9fd3b8c065119fddc412c40715784cc92329d22c01c655b"
    sha256 cellar: :any,                 ventura:       "9f3b96254d2b5ddddff97938832693cadf666c2ea7d9d6085eb8e04358f54b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ba262410561b5fcd350ddadb7b0704ccabca5d2556817caf5e3ab31560ef25"
  end

  keg_only :versioned_formula

  def install
    odie "Major version bumps need a new formula!" if version.major.to_s != name[/@(\d+)$/, 1]

    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system bin/"gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system bin/"gendict", "--uchars", "hello", "dict"
    end
  end
end
