class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/NBISweden/MrBayes.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f10a97438542d44f93ba830bc401fe8bd8d21e92a0ee9b398b9b76791e57ba3"
    sha256 cellar: :any,                 arm64_big_sur:  "09d39ce28dfe9f820b68cc23c70b8e4bf4b795b475c5b5ba9989be7476b780e3"
    sha256 cellar: :any,                 monterey:       "f6ebfc9fd1ccf792b1c385c42e5f8011158fb080f0a4370767f95646fbc6fa6b"
    sha256 cellar: :any,                 big_sur:        "f14702af22530faa81dd6e87fc240b4486408c1f14360fdf9b771c4f20a4e3f0"
    sha256 cellar: :any,                 catalina:       "2c9ad63eaaabbf59329ba205bbe37ef3b2650235931f86a921e08b43a5e9bdb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40751b431b49a864fcbf42fcf80eeb2ebc6cbd535152c226a6565371f8eb661e"
  end

  depends_on "pkg-config" => :build
  depends_on "beagle"
  depends_on "open-mpi"

  def install
    args = ["--with-mpi=yes"]
    if Hardware::CPU.intel? && build.bottle?
      args << "--disable-avx"
      # There is no argument to override AX_EXT SIMD auto-detection, which is done in
      # configure and adds -m<simd> to build flags and also defines HAVE_<simd> macros
      args << "ax_cv_have_sse41_cpu_ext=no" unless MacOS.version.requires_sse41?
      args << "ax_cv_have_sse42_cpu_ext=no" unless MacOS.version.requires_sse42?
      args << "ax_cv_have_sse4a_cpu_ext=no"
      args << "ax_cv_have_sha_cpu_ext=no"
      args << "ax_cv_have_aes_cpu_ext=no"
      args << "ax_cv_have_avx_os_support_ext=no"
      args << "ax_cv_have_avx512_os_support_ext=no"
    end
    system "./configure", *std_configure_args, *args
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
