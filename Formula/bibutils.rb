class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_7.2_src.tgz"
  sha256 "6e028aef1e8a6b3e5acef098584a7bb68708f35cfe74011b341c11fea5e4b5c3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/bibutils[._-]v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085548415c78f47a9185a323cc633d3005de95d1422e882f18393d7f7cf665cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe66061892ae39db121b9393cbce117888d4ba59aaa251269710f88d6b38b0eb"
    sha256 cellar: :any_skip_relocation, monterey:       "96d70048b4981355409b6620109d0acca787a9ae6a45a4c381a28bf8010b73f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "42fd33d5b6c68a038ea4f13be19e3ac741fcffab459a12501da19d939231d94e"
    sha256 cellar: :any_skip_relocation, catalina:       "6c5c8d31e9991599261ea6ec046d87f011ae2c3a42afe5d4e3fea07e38a69637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a5448e5df2d441e8e47dfb5115a9e16f8f239acce666093b85ec9ce7038c67"
  end

  def install
    system "./configure", "--install-dir", bin,
                          "--install-lib", lib
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS

    system "#{bin}/bib2xml", "test.bib"
  end
end
