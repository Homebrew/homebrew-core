class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.1.2.tar.gz"
  sha256 "75e228fd2978a7ee3372958bb66c9632a3c73bf3544c8933ef418156bfa4510f"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fae35ec49fd4c30cbd39ab0c8ef30641806ee2e563164d4f045b3886ed68daf3" => :catalina
    sha256 "ee6193354f35d6580c47f6adacf09a44967cb3e72d0d0e776f0c1c91f8815d51" => :mojave
    sha256 "ee6193354f35d6580c47f6adacf09a44967cb3e72d0d0e776f0c1c91f8815d51" => :high_sierra
    sha256 "4534817a20e0083d220ef5bc6707e4693e84025b12375cbba0d7ec86e972a3d1" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
