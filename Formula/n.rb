class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.0.0.tar.gz"
  sha256 "2933855140f980fc6d1d6103ea07cd4d915b17dea5e17e43921330ea89978b5b"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa91a97c1e099b6c7311252313dfd783661b223a600a5e4547e9ed8aebfbf3d4" => :big_sur
    sha256 "4dd46a8347ce1ddb74a8435dc872c235b4aa1117a919d3265d17880bf9b83a71" => :catalina
    sha256 "126c4d3a7d9717bd024176052107e6359b4ed1a2dca3d4d8f96ed6cfe9c5f626" => :mojave
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
