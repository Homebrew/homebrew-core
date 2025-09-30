class Prodigal < Formula
  desc "Microbial gene prediction"
  homepage "https://github.com/hyattpd/Prodigal"
  url "https://github.com/hyattpd/Prodigal/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "89094ad4bff5a8a8732d899f31cec350f5a4c27bcbdd12663f87c9d1f0ec599f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "53b753a4ebac8132ae38ba5c35f9c5466ea322b76bb87d4b408a11ace114ae9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0586dd1f22c8cdb1ed73c2eefc20f80ff3ad711cfb16e2f72ca7f72798161f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dfefaef30d736f08630c536dc66bfe2608c36793dde08eea5b3d13d3d7ff76f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a790b0ef414bf71bd6382b1e7e2acee149988003a3def80085c4ae555e436ed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf9c5deb46b542d95f4bcca4f4f947d60fee5138b76eab5018b61eb6f86279d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abcf0f632ae6187b7b29e2ebd9680717c3678d3e2694b87840591a0f51d4db09"
    sha256 cellar: :any_skip_relocation, sonoma:         "4430b671ce9d701a63214ed2f557cdd60ff9cf0809de53f494cc8709705cfd5a"
    sha256 cellar: :any_skip_relocation, ventura:        "8b27c484b78ade21719983f96701441033f3c8bc409f12db3678a4da740b108e"
    sha256 cellar: :any_skip_relocation, monterey:       "19a6b172b25f41612c11427cb12b19cca27580935c756ac5337c9bce27e3b4a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f61811f05bc3e784428dd1ece760e6375f2624b103393e1809ece54659d440c"
    sha256 cellar: :any_skip_relocation, catalina:       "5cebc25d98ba4439aa810c4e05c9f30e7ecf768035d135d0989cf58c18517a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82c184c80fe91b972ed50eccdbc1c80e99438d577f9a8decbe2083ae15a09b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9974eaeb5029133abe08d54412f419ea1159eda1dba47a6c89ee661e865285b2"
  end

  # Prodigal will have incorrect output if compiled with certain compilers.
  # This will be fixed in the next release. Also see:
  # https://github.com/hyattpd/Prodigal/issues/34
  # https://github.com/hyattpd/Prodigal/issues/41
  # https://github.com/hyattpd/Prodigal/pull/35
  patch do
    on_linux do
      url "https://github.com/hyattpd/Prodigal/commit/cbbb5db21d120f100724b69d5212cf1275ab3759.patch?full_index=1"
      sha256 "fd292c0a98412a7f2ed06d86e0e3f96a9ad698f6772990321ad56985323b99a6"
    end
  end

  # Avoid undefined behavior accessing array at index -1
  patch :DATA

  def install
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    fasta = <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "CDS", pipe_output("#{bin}/prodigal -q -p meta", fasta, 0)
  end
end

__END__
diff --git a/main.c b/main.c
index 0834a07..712135d 100644
--- a/main.c
+++ b/main.c
@@ -556,7 +556,7 @@ int main(int argc, char *argv[]) {
         score_nodes(seq, rseq, slen, nodes, nn, meta[i].tinf, closed, is_meta);
         record_overlapping_starts(nodes, nn, meta[i].tinf, 1);
         ipath = dprog(nodes, nn, meta[i].tinf, 1);
-        if(nodes[ipath].score > max_score) {
+        if(ipath >= 0 && nodes[ipath].score > max_score) {
           max_phase = i;
           max_score = nodes[ipath].score;
           eliminate_bad_genes(nodes, ipath, meta[i].tinf);
