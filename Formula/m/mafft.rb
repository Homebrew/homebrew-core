class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://gitlab.com/sysimm/mafft.git",
      tag:      "v7.525",
      revision: "a1e1e3f1bd468b0e47918840c7b82057f0fd1faa"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/The latest version is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7888d8cd90816aef36abaf14eb9c35f7e49d75b385df5fbee7fd3c9c8e085773"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecada47a14e316ea3b10c48766b5dedf018c68bb28bd045ad84b721b8353a813"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d05485bc2b5e3350bed7a3e36717cd31c57d8db8e11660fe84160d8e224e92"
    sha256 cellar: :any_skip_relocation, sonoma:         "2411c247ddbd7dd212453665c00ec00c7d8848d257b48be1123cf5b5cb448f79"
    sha256 cellar: :any_skip_relocation, ventura:        "cc9a9c74bf915a7a2186b155208f1ddf202afa0859532b92ebc5c2338083c902"
    sha256 cellar: :any_skip_relocation, monterey:       "376a10680342351d465b1a532393b52674d1ff20a6461fab9dc66fc69aa81c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d492fe9c55f20b5a9442fce995c888aa2b921166234676572598f69bb46c1859"
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
