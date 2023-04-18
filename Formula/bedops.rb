class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.41.tar.gz"
  sha256 "3b868c820d59dd38372417efc31e9be3fbdca8cf0a6b39f13fb2b822607d6194"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa0e42d870cb2e5fd71ecfe637ec760352eb571074aa19156564f8fd1fc0cb2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4716026be4f889b0c6ea10e8288be373cac72224aa63376b08192ab07f440d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "cfc5f580c14bc11bad34d5b8b5ff6b84180ef5238a86d7b67ab9ffde4699a611"
    sha256 cellar: :any_skip_relocation, monterey:       "044fcad68d63ce2863dc43d69cbcff7b0b8d519086565ab8a2fa654b07f78bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "12419efcde367c515fd963910d949141e3b95ff57c288730ba6e176499e519a2"
    sha256 cellar: :any_skip_relocation, catalina:       "394609dcde4bcafc5ce17c92e2fa0a0a98761aa7127c697c55af8bf66ae5838c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70293dadd6ad59de7bdb253081cb4b954b0b50008cd9f996ec81e30e043b83a"
  end

  def install
    system "make"
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    (testpath/"first.bed").write <<~EOS
      chr1\t100\t200
    EOS
    (testpath/"second.bed").write <<~EOS
      chr1\t300\t400
    EOS
    output = shell_output("#{bin}/bedops --complement first.bed second.bed")
    assert_match "chr1\t200\t300", output
  end
end
