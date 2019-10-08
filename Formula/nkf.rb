class Nkf < Formula
  desc "Network Kanji code conversion Filter (NKF)"
  homepage "https://osdn.net/projects/nkf/"
  # Canonical: https://osdn.net/dl/nkf/nkf-2.1.4.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nkf/70406/nkf-2.1.5.tar.gz"
  sha256 "d1a7df435847a79f2f33a92388bca1d90d1b837b1b56523dcafc4695165bad44"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a0694aedea8fcf96ecdfb6c60c0e14825591e7e7247e3944a00966d883398e6" => :catalina
    sha256 "85183c457daaecd9a3ce59cea556189ad0131c6134d77e7890643a3fb75e3965" => :mojave
    sha256 "9af47f293d4531c8d7ec5a81bd041349773f982b9710edca03eb3eb59b02a8b5" => :high_sierra
    sha256 "8d908ee97c34e85ed85c268c895e143d57c7afdd9bc232a75b690067281765fc" => :sierra
  end

  def install
    inreplace "Makefile", "$(prefix)/man", "$(prefix)/share/man"
    system "make", "CC=#{ENV.cc}"
    # Have to specify mkdir -p here since the intermediate directories
    # don't exist in an empty prefix
    system "make", "install", "prefix=#{prefix}", "MKDIR=mkdir -p"
  end

  test do
    system "#{bin}/nkf", "--version"
  end
end
