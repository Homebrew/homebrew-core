class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.12/nsis-3.12-src.tar.bz2"
  sha256 "f3ed7a8e4aa2cf4e8cf47d3b563a02559e0cb4934db2662b2f9661b824e2b186"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30fc5559f2153e11198181be077df17ea503b3f8366c750e935c09aa8f983fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd3e48a17b246308fd5e7e9b7c0dc2c3767f7c6f993f9ad58c649aab73b5387d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3829f573ed0d00e8313b859b3d9ee09ad705867921c24e44448deb192ebe206b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa6e3c1f949304b272071b24390acc89f5a1d6cdaaaa45cc5dd7922f9a79eee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d35d398b17e39668b091b993d9ec1f787e636ade0be83870dd489ad42bcee3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7366e169187d7d5b925e223e9d6d705980f7085910ea2efe876ca7184685bef6"
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
      ENV.append_to_cflags "-I#{Formula["zlib-ng-compat"].opt_include}"
      ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    end

    args = [
      "CC=#{ENV.cc}",
      "CXX=#{ENV.cxx}",
      "PREFIX=#{prefix}",
      "PREFIX_DOC=#{share}/nsis/Docs",
      "SKIPUTILS=Makensisw,NSIS Menu,zip2exe",
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
