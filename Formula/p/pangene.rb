class Pangene < Formula
  desc "Construct pangenome gene graphs"
  homepage "https://github.com/lh3/pangene"
  url "https://github.com/lh3/pangene/archive/refs/tags/v1.1.tar.gz"
  sha256 "9fbb6faa4d53b1e163a186375ca01bbac4395aa4c88d1ca00d155e751fb89cf8"
  license "MIT"
  head "https://github.com/lh3/pangene.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c6dbdfbc682f5845cae51d931b77a475097693bbd76343919365f2f3413a6e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08730dae3029ce76ebbf0bef953e839242f80bfd64f4ba430b7c94bf89b20a3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b448acf9c369e6a67524e8d7c68fb781c5f526a3c41a74679a251965c8a5de3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03ab1d6a2d24f4629689f39536fb9422f934b86eef4dd5d0ceafeb479140c472"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c86caf9ed1c9918e4286f785151b4af0b7e5fd665c430948c5eb0f14a8c8424"
    sha256 cellar: :any_skip_relocation, ventura:       "96ad645c4f2a6ae15cbf231a2e9b080fa3334d8b412e1c5dbdbe580bd66f6c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c01933d9ab50883be5455c7666cb5afadfaf1789eefb6613d8fdc51eeb9f9f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "487052e67934b027898914dcfec64d1805b0ab9f9457704c1bb5e2aed204d5a7"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "pangene"
    man1.install "pangene.1"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pangene --version")
    cp_r pkgshare/"test/C4/.", testpath
    output = shell_output("#{bin}/pangene 31_chimpanzee.paf.gz")
    assert_match "chimpanzee", output
  end
end
