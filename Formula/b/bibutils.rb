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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ac24439c4f2cf3ea608eb7b411d8094183796f81a3dee10e3ee550672e9ffae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9cd55399d769cbc1cab21cfad48bb843a8c8a7c0a966445c6530c88ba8361b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69d0da0d5cb6ef8cd905c782149b4212aa6e45beb171386672f0aa0fbe5a8f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a42ed6f44138819d700f274b2543a42e47e6f398039b23318d57a878a02cd07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085548415c78f47a9185a323cc633d3005de95d1422e882f18393d7f7cf665cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe66061892ae39db121b9393cbce117888d4ba59aaa251269710f88d6b38b0eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7d1848fce479f7adbd94a5134da4d4190ef8ec893674050c1f1ec19b70d5e43"
    sha256 cellar: :any_skip_relocation, ventura:        "31939f0ba7545b32ed0c2ad75c3efdad4bd08a6d81680a29bac20e3389fe51c6"
    sha256 cellar: :any_skip_relocation, monterey:       "96d70048b4981355409b6620109d0acca787a9ae6a45a4c381a28bf8010b73f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "42fd33d5b6c68a038ea4f13be19e3ac741fcffab459a12501da19d939231d94e"
    sha256 cellar: :any_skip_relocation, catalina:       "6c5c8d31e9991599261ea6ec046d87f011ae2c3a42afe5d4e3fea07e38a69637"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "df6b2c5da9590ef4ec1d5d4a89ee04e95542d84fe02c9f1e0eaf28af505e52ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a5448e5df2d441e8e47dfb5115a9e16f8f239acce666093b85ec9ce7038c67"
  end

  def install
    system "./configure", "--install-dir", bin,
                          "--install-lib", lib
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test.bib").write <<~BIBTEX
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    BIBTEX

    system bin/"bib2xml", "test.bib"
  end
end
