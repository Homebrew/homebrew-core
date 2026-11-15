class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.13/nsis-3.13-src.tar.bz2"
  sha256 "a8ffe024602d46b6d766f9e1ce30c324ad2a24daeacd3efc2642d436a0c157ac"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb902fdc6f21f2d0dee4f78d6a1350263901624217ed2ae591b94d107e665a38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7c507dc02c50a630db44948fc68ff4dea7c2bae64592d96d134952c2624ddc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02605964f5fb05003331867c10cf89dbfa0bf4eeeca7ee397787a4d8084837ac"
    sha256 cellar: :any,                 arm64_linux:       "4b830b3abe54cacaa0f575d8f15d92d59316629252105f30abf59f5f38e2ded8"
    sha256 cellar: :any,                 x86_64_linux:      "ffa86d93e3affc4cb033d75d66c7cc4369664850928ccf518c665e6669a0ad6a"
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.13/nsis-3.13.zip"
    sha256 "ba63dffc4410ee89193e1cb5a41989991bd77c61068da17e3156d136b7b0b3d8"

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
