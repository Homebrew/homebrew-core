class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.5/proteinortho-v6.3.5.tar.gz"
  sha256 "1b477657c44eeba304d3ec6d5179733d4c2b3857ad92dcbfe151564790328ce0"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb9d08681faf0c8464fa65b131900c097876bac2c1a3c340dfaa85ad3a459702"
    sha256 cellar: :any,                 arm64_sonoma:  "26e80497cc9d2284466a31dcc6dfd95357ea071ccc733c60eb0e79a086af374d"
    sha256 cellar: :any,                 arm64_ventura: "8e23bd4abefac07aca474bba3e4e56f469b38cd7e3c9e46f792e573710415009"
    sha256 cellar: :any,                 sonoma:        "e1862ac62a9b9b594a008d5e50c30faa0388224af3249a0b8f0f4f8ee1666aea"
    sha256 cellar: :any,                 ventura:       "fc7eddf0b7441b7bcf81cdf6fe97ebb3c53354a4f538569a5334f554338f6c86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833760c644e5a42573ff7166c7b1201a925847350deb7a8ff7e35fc7ba97a02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f93ee04f2ff9dc0c6a526f1567f6410deefaf8b4e340994ecd98734c9c685181"
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
