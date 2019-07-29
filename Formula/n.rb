class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v5.0.1.tar.gz"
  sha256 "a913f885f6b422779b451510df8b079e4e3504e6cfba72ff3e7d9fdba4db1e82"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81eb46b1e8aa88b8dd756550b839c278e4b2ece9617cd5e6c2f6998cfb630fd6" => :mojave
    sha256 "81eb46b1e8aa88b8dd756550b839c278e4b2ece9617cd5e6c2f6998cfb630fd6" => :high_sierra
    sha256 "cbea8d6f66d37a1de7c56cc6d4e3be04d975379e9911c4f80ca65dc7993aa3c2" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
