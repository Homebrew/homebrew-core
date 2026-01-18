class Mergelog < Formula
  desc "Merges httpd logs from web servers behind round-robin DNS"
  homepage "https://mergelog.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mergelog/mergelog/4.5/mergelog-4.5.tar.gz"
  sha256 "fd97c5b9ae88fbbf57d3be8d81c479e0df081ed9c4a0ada48b1ab8248a82676d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "aa756f494d4032e8a7a2f5f824471c7bbf71c98370e3c374343dddeb80a5720c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b831541094e323e374a379048f0f9beb6fba7267c03b282e1974cc59900dfa75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4216fbee6feb598e05ec9c55932afb3c291e6764492a95ae0c7ae07cfa3296e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a536e75a6e41c182c1eb0e0328bc2ab2a6aef63e9617a7206048c5006527d0ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1c9f43d4bc60ec22734380dff9843797661be4e0b1b0ab2d861d25a9886cfd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dac9051c91f80333b2640675187bdc2c93705183d3d119998e300e0137c0bff"
    sha256 cellar: :any_skip_relocation, sonoma:         "acdb09120c3187ec8233513479297bd0da71e3e1d2d3236f2be93e396f395c70"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4dd9ac26e877acc2f2c86ced6cb68488aa234735027b0a978d247995bc270d"
    sha256 cellar: :any_skip_relocation, monterey:       "5814e07c1a51eaaa8793749baba836be66ae9fcfaeb2493cc86aaed15c9fb02c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e778308b66cc9a27d21d41e17c97cf9f7aeef4e5da797eaadc5f2264c103b8c0"
    sha256 cellar: :any_skip_relocation, catalina:       "41acae4f1614c4ba0a3ea3e05bb88c150c930a07c50560df1d4bfc4a49c9bdf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "09cf79df48692a01b15e1a7a8aed68310cae89597000c500b05f164816e91655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f3e79e1bdb70b4094c813fda9442f858828cbff21f19ba6a239628a0a53605f"
  end

  uses_from_macos "zlib"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "src/Makefile.in", "mergelog.c -o", "mergelog.c $(LIBS) -o" unless OS.mac?
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mergelog", File::NULL
  end
end
