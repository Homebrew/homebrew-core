class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://ecl.common-lisp.dev"
  url "https://ecl.common-lisp.dev/static/files/release/ecl-24.5.10.tgz"
  sha256 "e4ea65bb1861e0e495386bfa8bc673bd014e96d3cf9d91e9038f91435cbe622b"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  livecheck do
    url "https://ecl.common-lisp.dev/static/files/release/"
    regex(/href=.*?ecl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:    "792a14c129f90bf2d9394da6c7af284e69548a20f0928b9623b36d3aa7261545"
    sha256 arm64_sequoia:  "04a0ce4228cb34b3dc85b14755a96f61c698d9a3b35c3459d6f228a0e87fe5df"
    sha256 arm64_sonoma:   "f511628793d569db33a5d91a96a052eff9a7bcc922717941c7e5dd3a08a32d34"
    sha256 arm64_ventura:  "6e4978801eb0b6cf26e5bccd502ce82e5b4c5ba7213aedd23fd39ee6e639d3e7"
    sha256 arm64_monterey: "38a0407a7998ec9218775d7eeafec3703cbbe823298383bee875b32113f23fae"
    sha256 sonoma:         "2a29cff3a5684dc0171d182ca98308ffd5f16336500b03e3352c40f699bd999e"
    sha256 ventura:        "538afbf26399d650b672ddd2013103ac4faacea950ec92531afc00bb8a6fd583"
    sha256 monterey:       "95e261506d9cbb74e121eb52f281c516012d971d0b88887b9116b74a82144e8e"
    sha256 arm64_linux:    "5693dbc0e01cdaf463ca0ab804fb0454b9739d7c53b64fb421f2c4422e41fec2"
    sha256 x86_64_linux:   "fcc4ecc3ffdf65a6d96712a835d80711d804f643139208fe49ea029296a0a1dc"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  uses_from_macos "libffi"

  def install
    ENV.deparallelize

    libffi_prefix = if OS.mac?
      MacOS.sdk_path
    else
      Formula["libffi"].opt_prefix
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{libffi_prefix}",
                          "--with-libgc-prefix=#{Formula["bdw-gc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
