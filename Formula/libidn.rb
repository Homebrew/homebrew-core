class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.38.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.38.tar.gz"
  sha256 "de00b840f757cd3bb14dd9a20d5936473235ddcba06d4bc2da804654b8bbf0f6"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_monterey: "b36c5a702e23a79b713fa8ef1cde2f45f3547507146928d25649e34704b89810"
    sha256 cellar: :any, arm64_big_sur:  "7b3adb7115f8e786852ce270f633f726525f0017ce2f44b99b1b05c42c672c25"
    sha256 cellar: :any, monterey:       "97ae6e40039b1abaa15ea01851a407c6330ece0687f436fcac14f2ed1ed7bfee"
    sha256 cellar: :any, big_sur:        "edf0fcd338457708fb6ee986f85c380b744d7ea7b9e03df1bec892959d2a9e0d"
    sha256 cellar: :any, catalina:       "ce069c2b604d6dd0194541bc510a43d0e1eecacd816dfa4d2f537dde7de3cd5f"
    sha256 cellar: :any, mojave:         "1e5c4afc066727df497031e2cefbd012fc7b5b4e4cee793cd4b84f68bf9ff3de"
    sha256               x86_64_linux:   "cdebd0a0f73d6fe29f8ef539aa1be4a8f576245aa07697de123bf436bfdd24d0"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
