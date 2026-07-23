class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/refs/tags/v3.2.7a.tar.gz"
  version "3.2.7a"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  license "GPL-3.0-or-later"
  head "https://github.com/NBISweden/MrBayes.git", branch: "develop"

  livecheck do
    url "https://nbisweden.github.io/MrBayes/download.html"
    regex(%r{href=\s*.*?/NBISweden/MrBayes/archive/v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e0813e7f10eb1abadd4172e54fc18d7fac02f2a2521d3034217ea8ee99ffa04"
    sha256 cellar: :any,                 arm64_sequoia: "098da5cbc7c3371cbc845399356634f3373723ab9a10813af39420706adc495b"
    sha256 cellar: :any,                 arm64_sonoma:  "3297974985b7c483dad355decca53663b6dd88f9aff0571200997b491a44d582"
    sha256 cellar: :any,                 sonoma:        "4e22bb908f3d2fabacebe0f1896de5cc05f74b5a1bcd224fb2fa85585db5074c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b2aaf7489371e64e11bc0dde781218fd8b4a85a41cd7db039f2a8c377f726c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7379add8dcffcc268785b68f80f88fb0478f10c76ef139b43b0c6983e30675"
  end

  depends_on "pkgconf" => :build
  depends_on "beagle"
  depends_on "open-mpi"

  def install
    args = ["--with-mpi=yes"]
    if Hardware::CPU.intel?
      args << "--disable-avx"
      # There is no argument to override AX_EXT SIMD auto-detection, which is done in
      # configure and adds -m<simd> to build flags and also defines HAVE_<simd> macros
      if OS.mac?
        args << "ax_cv_have_sse41_cpu_ext=no" unless MacOS.version.requires_sse41?
        args << "ax_cv_have_sse42_cpu_ext=no" unless MacOS.version.requires_sse42?
      else
        args << "ax_cv_have_sse41_cpu_ext=no"
        args << "ax_cv_have_sse42_cpu_ext=no"
      end
      args << "ax_cv_have_sse4a_cpu_ext=no"
      args << "ax_cv_have_sha_cpu_ext=no"
      args << "ax_cv_have_aes_cpu_ext=no"
      args << "ax_cv_have_avx_os_support_ext=no"
      args << "ax_cv_have_avx512_os_support_ext=no"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"

    doc.install share/"examples/mrbayes" => "examples"
  end

  test do
    cp doc/"examples/primates.nex", testpath
    cmd = "mcmc ngen = 5000; sump; sumt;"
    cmd = "set usebeagle=yes beagledevice=cpu;" + cmd
    inreplace "primates.nex", "end;", cmd + "\n\nend;"
    system bin/"mb", "primates.nex"
  end
end
