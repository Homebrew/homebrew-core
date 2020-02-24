class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.3.tar.gz"
  sha256 "0186bf40af67032666014971ed8ddc3cf2834bebc2be5b3bc0304a93e763736c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7d65153f779a1de7196a6434617eb870a9aa7a8edfd8abc58bc36fecd61da2d" => :catalina
    sha256 "f31890fbde868fc82a2820f17174eb905144f4dea67d5d91a88363645279341b" => :mojave
    sha256 "c2343ad2d3c2fc7a1b02bda605096cb3efc895be458eb219a0e8eee3cc805474" => :high_sierra
    sha256 "81c3660f5c0c9a7ef21dbca50e6f871bf1ea48af8e59de293e988e682dc16e6e" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/Pkinase.hmm")
  end
end
