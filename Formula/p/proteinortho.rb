class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.6/proteinortho-v6.3.6.tar.gz"
  sha256 "2e41c9698bb7eaacdde242233e3a1643b429587d4b458577ecc5be2e752a2be5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91f55f765f3656a53a7b3a1725c7998f282544133755ed3eab45df72a28e59eb"
    sha256 cellar: :any,                 arm64_sequoia: "4006d9977aa6a7393f902a01fc9a229258c075f04a6f4bae1167c513f4182dd7"
    sha256 cellar: :any,                 arm64_sonoma:  "7cbff76f79a4ccc38517c9c839a7398fa09d3be50040619eb0b5cac6d555d376"
    sha256 cellar: :any,                 arm64_ventura: "14bc4553c7280b330912079c579c06d33a7a2f14d51469638d583088909ed8d5"
    sha256 cellar: :any,                 sonoma:        "43fec91bde54c6e2dd98c7638b186f1154994e36333f0bb4d996f5b283341f9c"
    sha256 cellar: :any,                 ventura:       "619a56ae341233fc034ad5108375991c3ad44ce35a8d17b072c73b95d126c76e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34176fe378a8eecdb6c09cd40bf4c92344fb528cb60f0b95e5123e8e70e6d4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b51d536e573f48acbf32d863ed493217e2d9cda3be9c810e1cd0d9301cf87d9"
  end

  depends_on "diamond"
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  def install
    ENV.cxx11

    # Enable OpenMP
    if OS.mac?
      ENV.append_to_cflags "-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp"
    end

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
    pkgshare.install "test"
  end

  test do
    system bin/"proteinortho", "-test"
    system bin/"proteinortho_clustering", "-test"

    # This test exercises OpenMP
    cp_r pkgshare/"test", testpath
    files = Dir[testpath/"test/*.faa"]
    system bin/"proteinortho", *files
  end
end
