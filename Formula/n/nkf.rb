class Nkf < Formula
  desc "Network Kanji code conversion Filter (NKF)"
  homepage "https://osdn.net/projects/nkf/"
  # Canonical: https://osdn.net/dl/nkf/nkf-2.1.4.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nkf/70406/nkf-2.1.5.tar.gz"
  sha256 "d1a7df435847a79f2f33a92388bca1d90d1b837b1b56523dcafc4695165bad44"

  livecheck do
    url "https://osdn.net/projects/nkf/releases/"
    regex(%r{=.*?rel/nkf/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcc652ba1cfeec1bec89e5108c3e6eae31652606bf7babd5af25dc6522dc44a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd946546a2e3f86974d8d6685e891efaca8e4b609ba64cb537629a9b371df518"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85bfff310d48fea503f95092b12a3a2fa19b48ba634cbbdb84c083b8701cd948"
    sha256 cellar: :any_skip_relocation, ventura:        "88af0934e1a4eb4750fcca73d2cdf3b84219d7ca4f1995f86048da271102bec0"
    sha256 cellar: :any_skip_relocation, monterey:       "bdf97f3712176e9da065dcacabede2187d244e201a6f326bda4d227a259e75fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a30c72ca018734cf05b3e029d4e5d3eb6297f847da07e699f9891558480ad4"
    sha256 cellar: :any_skip_relocation, catalina:       "4a0694aedea8fcf96ecdfb6c60c0e14825591e7e7247e3944a00966d883398e6"
    sha256 cellar: :any_skip_relocation, mojave:         "85183c457daaecd9a3ce59cea556189ad0131c6134d77e7890643a3fb75e3965"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9af47f293d4531c8d7ec5a81bd041349773f982b9710edca03eb3eb59b02a8b5"
    sha256 cellar: :any_skip_relocation, sierra:         "8d908ee97c34e85ed85c268c895e143d57c7afdd9bc232a75b690067281765fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03ddaa51a6fc6341348d4ee40c5a0a7309817b9fb957171b01b8aeab6ea6fe25"
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
