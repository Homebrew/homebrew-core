class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.4.0.tar.gz"
  sha256 "580ea6a41f5a1cdbc7ef4a64c45f1a48d97e1e173ae18457fd980bc75dde3c3a"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e908d7a75aaa2ee3081243858739e8f6306053dba5ffd4bf3116b5910c7a471" => :catalina
    sha256 "7e908d7a75aaa2ee3081243858739e8f6306053dba5ffd4bf3116b5910c7a471" => :mojave
    sha256 "7e908d7a75aaa2ee3081243858739e8f6306053dba5ffd4bf3116b5910c7a471" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
