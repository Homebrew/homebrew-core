class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  url "https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "cedd760e3faf61b03a40db75fcd304b46d60a17d3a5e868e6422162a6a522b47"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da40274ea88ca3f0b1c07ff960b414be3b9c6a9fb4298711ebf165737f8245b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b11e1ae3c102ac630c65a2ba2bc7e1bf67cbdc977008c169a1fd1d897bdd18bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b114761dd31fbf7f32a151c1539bbfff662a9abaf0cadd9fc71db534fbd291ec"
    sha256 cellar: :any,                 arm64_linux:   "1eadd47bfe4a9e9f9dd40b25124ef7e40d4a9e1d079b347656b73bee4c2834e6"
    sha256 cellar: :any,                 x86_64_linux:  "fbf6bb0079d6951d3d6efba50ec9f5af34b1a6b03720dde4dea1a62ed32bccb2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    bin.mkpath
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp Dir["#{pkgshare}/EXAMPLE/HAP*.fasta.gz"], testpath
    system bin/"FastGA", "-vk", "-1:H1vH2", "HAP1", "HAP2"
    assert_path_exists "H1vH2.1aln"
  end
end
