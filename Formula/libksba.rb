class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.2.tar.bz2"
  sha256 "fce01ccac59812bddadffacff017dac2e4762bdb6ebc6ffe06f6ed4f6192c971"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "846abeac7d61edb4ce5821dceda6d6868a81e6e00478bf822e3d3b8c5b37dd18"
    sha256 cellar: :any,                 arm64_big_sur:  "2dc564e399f97012c3d123e26b6b866dd4260e0525213555873aac98c0a2b870"
    sha256 cellar: :any,                 monterey:       "1f6a8d065218a3d9e2958d2baa5a94777178e4eb38329cc3aee6cd748c7cbf93"
    sha256 cellar: :any,                 big_sur:        "0596d94b8681d6d1cec06ddfbd7efd20bef2dcd409bad38a36a37e9d907f285e"
    sha256 cellar: :any,                 catalina:       "462c0376fc39e903e2c6cde3124cd5550adacb064d08a6632698beeb7255c0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fac2e0436d56a611ba26855207d3d3f2c3ec21465e2b23cd66fb012ff727463a"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"ksba-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
