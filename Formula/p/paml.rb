class Paml < Formula
  desc "Phylogenetic analyses of DNA or protein sequences using maximum likelihood"
  homepage "https://github.com/abacus-gene/paml"
  url "https://github.com/abacus-gene/paml/archive/refs/tags/v4.10.10.tar.gz"
  sha256 "173e8754ad78000371099a96910f2c72b03a7b7b13c717405dc23385ae2f2c0f"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "434830dea471f09bec75f37f545e7b01916f53c3d7f875d080d5def4448d4616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "443dd055dd35ad3a962978b706c18d021c85ebf76da01bde7c2fe5e52727b1df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e9b78abbdd2e79bdce13d00521319c55937145361b567a4ea40e63e1670cf1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d4b890f5e50b18ab5cecd7512b20b5b1daa81eb47cba245f3255d44ca3c4578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6339446198ddbb17ce131bce01517752c96ec43cac784db4dd3a2d485a024b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece7f24ec3026fd916a2dcc46366697a9924874774ab8a6d48f77f1b5f5a4310"
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00]
    end
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    output = shell_output("#{bin}/baseml baseml.ctl")
    assert_match version.to_s, output
    assert_match "lnL", output
  end
end
