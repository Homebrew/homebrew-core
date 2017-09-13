class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.7.tar.gz"
  sha256 "2ba3c9d4dd3c7e38885b37e02337906a1ee91febe6d5c9159d89a9050f2eea8f"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33b215f0d3ee9bd1182b261025621f01ee42c0cc452475f206673e62e97b1092" => :sierra
    sha256 "65df30f85c36938e4c0c608e9849d784213dda13d717989755965377c74ae7a9" => :el_capitan
    sha256 "65df30f85c36938e4c0c608e9849d784213dda13d717989755965377c74ae7a9" => :yosemite
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
