class Icu4cAT75 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-75-1/icu4c-75_1-src.tgz"
  version "75.1"
  sha256 "cb968df3e4d2e87e8b11c49a5d01c787bd13b9545280fc6642f826527618caef"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7e245c13a6a784dbdfc1b0e52abab9f159d684f8ae6d9293c585bd21b441e75"
    sha256 cellar: :any,                 arm64_sonoma:  "3da9b88cf2f84e5f37d964400a7a8e1a2042d3dda33acf7eb9c2d81e785e0532"
    sha256 cellar: :any,                 arm64_ventura: "760542f48a7cc4e7aff89d5a9c3030fe549e51753a5f7167d838f48fa9a8df38"
    sha256 cellar: :any,                 sonoma:        "b8d525ce3c6f163981641f69920b6ed92cf4bfef7dab84979dc8f49777d7ea3b"
    sha256 cellar: :any,                 ventura:       "e040d0d6cb994165a20ce9fdcc691ea15043b1c583c9af9a18e7a2ac63aaabcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab60784f7aee6a4a7827bbff1cf524c1c357a76be2898fdbf144ffa1df145eff"
  end

  # TODO: Switch keg_only reason after renaming `icu4c` formula to `icu4c@74` and updating alias to `icu4c@75`
  # keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"
  keg_only :versioned_formula

  def install
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
