class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.11/nsis-3.11-src.tar.bz2"
  sha256 "19e72062676ebdc67c11dc032ba80b979cdbffd3886c60b04bb442cdd401ff4b"
  license "Zlib"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37bf97b867b0e8d8dd1322e5e330a2345d941934417e1c7bc956dd6ef02f265d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "788a8a8f9daabfadfa6a8e57574cbf7761fe148758fb757217855f87719b52ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d006d850db7d168f29ab56ca64ae67321e01111fb146c93aa6d4f25a006146"
    sha256 cellar: :any_skip_relocation, sonoma:        "031c1099e339009d054af61e9665dad745136eec93085b639c2bc8f2d0e30b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "668f6299c22e38c737e7b56d9843bc0d8d50a65d0433626a4a05667841cc393d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "591f9144c014b90068724623f2b6acee6e58ea6811e2c1ffc99c0d9dd2dbf0f3"
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.11/nsis-3.11.zip"
    sha256 "c7d27f780ddb6cffb4730138cd1591e841f4b7edb155856901cdf5f214394fa1"

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
