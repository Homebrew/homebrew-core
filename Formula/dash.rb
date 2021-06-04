class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.4.tar.gz"
  sha256 "4e15b7ba5363bcc2a443549910cdc15b5ad601df8196b5f294c712eff037e08d"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96fae96e4f6797c2ba6109a61ccf2ae29490206401c601ca1af74d16c1468d47"
    sha256 cellar: :any_skip_relocation, big_sur:       "62ab16e52b3e756798263305a6912bfef23887fce354dd5322b4a41d2c76edd2"
    sha256 cellar: :any_skip_relocation, catalina:      "fb00c85446d5884bf836ee3dd2c0756d8291820f2c8098e2ad0674ddc17d22f2"
    sha256 cellar: :any_skip_relocation, mojave:        "1046e39d35af2b4a0a1b21ca8455015e0a3d61a79374db2079b072ab4e560ac7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
