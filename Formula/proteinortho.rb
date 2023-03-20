class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.2.0/proteinortho-v6.2.0.tar.gz"
  sha256 "7f363d14f2a74cf972d25bd168c1a711c9e51ba67de2f8071676371565d52f42"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73a6e13bb5c2348bd332aeb33817e0a40fcca2fdde79c6d1ee018a09ae13961a"
    sha256 cellar: :any,                 arm64_monterey: "d999b4ebff18e9af0040230fff670c1228796308ef35f08367fb669c3669dd40"
    sha256 cellar: :any,                 arm64_big_sur:  "a675618f8e83801cce59fd8b513bf65373ffda7ae7b1f635c0a23ab1a13ee9fc"
    sha256 cellar: :any,                 ventura:        "44aa940617c21a7629d42483be1762a4527de349eccf980ec26137b0b1e19dd7"
    sha256 cellar: :any,                 monterey:       "8ba5a4f1d2884b5346fe5283d2150ce6afb2fd917270e29a4165537bb02862ae"
    sha256 cellar: :any,                 big_sur:        "729011fc4d31d146bee56ca8c6395eff8af9e2352ecb3639be3903c1567967e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bafd5b21a282f09365a4b9e9a3b5f5cda891d6833df71a0706c251f1151e11d1"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
