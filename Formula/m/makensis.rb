class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.12/nsis-3.12-src.tar.bz2"
  sha256 "f3ed7a8e4aa2cf4e8cf47d3b563a02559e0cb4934db2662b2f9661b824e2b186"
  license "Zlib"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "864af32755ca54ded9664cf2dc5340248f5ea16f1fe01796cf9e3c63de09638b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "159c8964f2d0312ed91441a05b111e945c65e7db6656e6399f787ca0da616e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7d8424fa7801a3f9bfa4e8bae1ffb5c8b4df6e48abf79d01a9533524fd8c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b482291c76d7965a7c535ee2fddbca5f76a0e018100f6f4950ab92c25967e1d"
    sha256 cellar: :any,                 arm64_linux:   "f36b465469553f0cd0503aa4093386237a9c95f318b8f00008ab568faec627ef"
    sha256 cellar: :any,                 x86_64_linux:  "6c1c684f418c02c44af554592161ee8ce1defa11ccab493e5a6e06df70b78fac"
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.12/nsis-3.12.zip"
    sha256 "56581f90db321581c5381193d796fffcf2d24b2f8fed2160a6c6a3baa67f2c4f"

    livecheck do
      formula :parent
    end
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{formula_opt_include("zlib-ng-compat")}"
      ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    end

    args = [
      "CC=#{ENV.cc}",
      "CXX=#{ENV.cxx}",
      "PREFIX=#{prefix}",
      "PREFIX_DOC=#{share}/nsis/Docs",
      # Don't build precompiled binaries
      "SKIPMISC=all",
      "SKIPPLUGINS=all",
      "SKIPSTUBS=all",
      "SKIPUTILS=all",
      # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
      "STRIP=0",
      "VERSION=#{version}",
      # Scons dependency disables superenv in brew
      "APPEND_CCFLAGS=#{ENV.cflags}",
      "APPEND_LINKFLAGS=#{ENV.ldflags}",
    ]

    system "scons", "makensis", *args
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    # Workaround for https://sourceforge.net/p/nsis/bugs/1165/
    ENV["LANG"] = "en_GB.UTF-8"
    %w[COLLATE CTYPE MESSAGES MONETARY NUMERIC TIME].each do |lc_var|
      ENV["LC_#{lc_var}"] = "en_GB.UTF-8"
    end

    system bin/"makensis", "-VERSION"
    system bin/"makensis", "#{share}/nsis/Examples/bigtest.nsi", "-XOutfile /dev/null"
  end
end
