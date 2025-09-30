class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftpmirror.gnu.org/gnu/libidn/libidn-1.43.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.43.tar.gz"
  sha256 "bdc662c12d041b2539d0e638f3a6e741130cdb33a644ef3496963a443482d164"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "16554b492c8460ae8e23e3886bef64a944c2cd3bc4314e7df80971272b6173a3"
    sha256 cellar: :any, arm64_sequoia: "6a860a721a7e58991f845df9cd497758f193eb531ca2ba3a79e323f65e774dab"
    sha256 cellar: :any, arm64_sonoma:  "fac2bde8f325428b34f138b6f16b9f58ec0e5092e28a8abb0ac764d54930c98f"
    sha256 cellar: :any, arm64_ventura: "979bfd799362cbb1449dc2fba0094d6101b9b3744aa3b7d697f0a41e957777f9"
    sha256 cellar: :any, sonoma:        "2740c8bf1ca703ab181f9f6ebc11830512af175060ba02b85fa679174dc5ed2d"
    sha256 cellar: :any, ventura:       "3e91193d063ba22fdd1eba3280ce2230729fde70809eb4da4670dd8403eec674"
    sha256               arm64_linux:   "dc58733f88f4096f5d5119d84a59a691c8eebf66d4ff1942f8b5661a7a9a413d"
    sha256               x86_64_linux:  "89ab2ccb40a9c74ffbbde3b5ac2841c3200f07694d114175e0beb3b3bc31f31c"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--disable-csharp",
                          "--with-lispdir=#{elisp}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
