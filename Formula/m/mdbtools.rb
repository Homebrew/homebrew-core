class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/mdbtools/mdbtools/"
  url "https://github.com/mdbtools/mdbtools/releases/download/v1.0.1/mdbtools-1.0.1.tar.gz"
  sha256 "ff9c425a88bc20bf9318a332eec50b17e77896eef65a0e69415ccb4e396d1812"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80daadbae2b628dbc1e33e475a690da0c637cee4c0619e8f6fb462ec08833820"
    sha256 cellar: :any,                 arm64_sequoia: "5f908724216744cf5088aa9ca1418608ca0837be3b34c50d279d1465c7f030b9"
    sha256 cellar: :any,                 arm64_sonoma:  "0a2ee9cb19efc344da22dd3579c83100d225870c5dc2fd956c7ebf3ffdc1d07f"
    sha256 cellar: :any,                 sonoma:        "3432d36eac18a64fa6031f2e0d6ed953abd4fb5d366e61654b1aea738cb6460b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb0e0f717a7c20e7ea65cc3027034bcb3bb1c3673e118cba2609aca30f681cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d76da42e34993527918db173bda6ba69364963dcd3fc4553d7b8def90a8ab0"
  end

  depends_on "bison" => :build
  depends_on "gawk" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "flex" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--enable-man",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mdb-schema --drop-table test 2>&1", 1)

    expected_output = <<~EOS
      File not found
      Could not open file
    EOS
    assert_match expected_output, output
  end
end
