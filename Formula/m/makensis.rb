class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.09/nsis-3.09-src.tar.bz2"
  sha256 "0cd846c6e9c59068020a87bfca556d4c630f2c5d554c1098024425242ddc56e2"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e5ff651a001ea3c3afebae523d1f30b914d3054220bc9266a6101c7c134da2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f09cd2796953aab5c3198adcde8e9ba8d284ce46891417bedc949b95dea67a7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12c2c787c4fe84e6c72c410e7123040924ab731ab5d4659ed624a31e7a169180"
    sha256 cellar: :any_skip_relocation, ventura:        "a45fa4bb934cbbca70e30765ebcfb3ca4e5315f960b7a4b5ba2d4ebb6f2ff177"
    sha256 cellar: :any_skip_relocation, monterey:       "9fa2f365fd3229de093b66a3695ce4558c4822cdc61b26d8ad7a06d4fd7f79c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0dcee39ebe9e01f9cc0e2119978273fc46cb0ce34dc9b4272bf3b4184531b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920f67e5ec564bcfbe843661c6b12badf23fb7dcf8783719055c0fc9ed363158"
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  uses_from_macos "zlib"

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.09/nsis-3.09.zip"
    sha256 "f5dc52eef1f3884230520199bac6f36b82d643d86b003ce51bd24b05c6ba7c91"
  end

  def install
    args = [
      "CC=#{ENV.cc}",
      "CXX=#{ENV.cxx}",
      "PREFIX=#{prefix}",
      "PREFIX_DOC=#{share}/nsis/Docs",
      "SKIPUTILS=Makensisw,NSIS Menu,zip2exe",
      # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
      "STRIP=0",
      "VERSION=#{version}",
    ]
    args << "APPEND_LINKFLAGS=-Wl,-rpath,#{rpath}" if OS.linux?

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

    system "#{bin}/makensis", "-VERSION"
    system "#{bin}/makensis", "#{share}/nsis/Examples/bigtest.nsi", "-XOutfile /dev/null"
  end
end
