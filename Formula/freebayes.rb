class Freebayes < Formula
  desc "Bayesian haplotype-based genetic polymorphism discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/freebayes/freebayes/releases/download/v1.3.6/freebayes-1.3.6-src.tar.gz"
  sha256 "6016c1e58fdf34a1f6f77b720dd8e12e13a127f7cbac9c747e47954561b437f5"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/tiny/.", testpath
    output = shell_output("#{bin}/freebayes -f q.fa NA12878.chr22.tiny.bam")
    assert_match "q\t186", output
  end
end
