class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.11/nsis-3.11-src.tar.bz2"
  sha256 "19e72062676ebdc67c11dc032ba80b979cdbffd3886c60b04bb442cdd401ff4b"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2977f4bff74d9073ff6a05a8a072f30b8263137b39fa51094ef816d6b58c6a00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd2d0dcc5ca368334522b123210e7d9d3336efc5e0091f12500fa02a8e304d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065f088b4c9681f571c8e73b76bcd730ac34b5ab86ac011707d31b28479b8533"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71dd1af5b0c2c9a040bac2d58965ba3141dbb2c23a95f36d7ad7fb2b2e1b40fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "985171f35c2c617499f333b4926367ee656660b85e9a83c045a691633e1af9d1"
    sha256 cellar: :any_skip_relocation, ventura:       "b41b708bb2a20b5f006d3123070d7a9d16c02796201a86fa5456b7673a299994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "232ea0628f6282522669f5d4763bfe740ce920696e1f4fb0e5c68f4eabc186c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8e1672901d8376fcbcc0579302f0338629852fde0a262cdab694613fe89785"
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  uses_from_macos "zlib"

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.11/nsis-3.11.zip"
    sha256 "c7d27f780ddb6cffb4730138cd1591e841f4b7edb155856901cdf5f214394fa1"

    livecheck do
      formula :parent
    end
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}"
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
