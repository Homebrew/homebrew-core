class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.38.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.38.tar.gz"
  sha256 "de00b840f757cd3bb14dd9a20d5936473235ddcba06d4bc2da804654b8bbf0f6"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "79692bf3eba59bf205124de0cce8170c209b0f1f107b100e5f5e0c3147aa8234"
    sha256 cellar: :any, big_sur:       "87d313494a3bc28a705bb14a7786cd4fe67396138420847f9847cfd3b946a460"
    sha256 cellar: :any, catalina:      "0666177059ee07be7e9e05a61111e6366771a1cc4816d601726e77e0cc366275"
    sha256 cellar: :any, mojave:        "037373c763773d8205caf3123f3e4d6bc5ca42099888e786525174f864ac544e"
    sha256               x86_64_linux:  "b48720fbdd73cdfae3bbcda6cd18dbe00c2d8511df485ca52ee13321ee1282dc"
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
