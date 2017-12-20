class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.3.tar.gz"
  sha256 "75e2ce17e17918eb4e79d4ac46d99ba1a5e7c0808b7973fb191c6177b2e5755a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf8cb7cca976af1938f9b4d5a4674ebc425f4618ec512d82d2067caf0540230a" => :high_sierra
    sha256 "83aada5f73d20e62f4eb66c7da84881414fa9a8c96556ec6b0e8e52877180c99" => :sierra
    sha256 "ba3223b30e3a3ee63017510147aa32bdbeec78ead97622af4d39761150e8c11b" => :el_capitan
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
