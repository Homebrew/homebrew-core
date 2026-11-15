class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/refs/tags/v3.2.8.tar.gz"
  sha256 "331ceb0af036d07cd8bd7091d39632f6d102d8b98c160409d19df3958db85dc2"
  license "GPL-3.0-or-later"
  head "https://github.com/NBISweden/MrBayes.git", branch: "develop"

  livecheck do
    url "https://nbisweden.github.io/MrBayes/download.html"
    regex(%r{href=\s*.*?/NBISweden/MrBayes/archive/v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2198adef427b45f96b95d14dcba9b9e30e857f643212e96c4c3435ee9e48d774"
    sha256 cellar: :any, arm64_tahoe:       "c9871b950fc0607aaf979461cf5d067c01f670f8ebac0ceaa9ee2be6d5c2faf4"
    sha256 cellar: :any, arm64_sequoia:     "85913540941f7795ca1dffb21cda7a1b13f4966bbe45efff26283a412fe2e363"
    sha256 cellar: :any, arm64_linux:       "fa29744a5aa6b88758e48035f6f5e02507ef0161d623b72f7f415921c2dff1c8"
    sha256 cellar: :any, x86_64_linux:      "1d68660d7a570f0f14d90c5dd10cc198e6e086f7742680adceecedfa9bd5869e"
  end

  depends_on "pkgconf" => :build
  depends_on "beagle"
  depends_on "open-mpi"

  deny_network_access!

  def install
    args = ["--with-mpi=yes"]
    if Hardware::CPU.intel?
      args << "--disable-avx"
      # There is no argument to override AX_EXT SIMD auto-detection, which is done in
      # configure and adds -m<simd> to build flags and also defines HAVE_<simd> macros
      args << "ax_cv_have_sse41_cpu_ext=no"
      args << "ax_cv_have_sse42_cpu_ext=no"
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
