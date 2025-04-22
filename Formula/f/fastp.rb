class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "dd8a1b7e0410a800f80939e4d14b116e90bbec83ef7294a5f13fdaaba3fcc719"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1d632493ed11e7c6db44c6265d9936f00026a0012ce2a2c42f6a39c224409d7"
    sha256 cellar: :any,                 arm64_sonoma:  "7726820f8746ddc91660e300e03e1752de97d00d05da3246058a3e74b1fd9fbb"
    sha256 cellar: :any,                 arm64_ventura: "607b3abec7359671bdd813a97e884e1440ff06e8447415dbb211863f08876016"
    sha256 cellar: :any,                 sonoma:        "b057cf1f75d8be26c6f54c4da3a787de2b519c1a98d82912cc988a4089a318ee"
    sha256 cellar: :any,                 ventura:       "69b7ab175dd72f8eb15f2a40dcfee38636ba96d056fc7dd61cd437595d304481"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b0013a05762141221ea1c320ba1c17a77f824083cc816b52d63c16a2060b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc80baf649052c86fbcfe150552298c3036804a15217395ab4bd4528295e475"
  end

  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_path_exists testpath/"out.fq"
  end
end
