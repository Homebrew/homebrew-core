class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "5914f0d5e89aadaaaeb803baa89a7582747b0c57ad30201b3522cd76f504c7d9"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3c9c7f8da6a1a735450f6e1b7a49483aa878ef6dc4657e68f4d3bb238cade1c2"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
