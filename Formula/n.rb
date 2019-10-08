class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.0.1.tar.gz"
  sha256 "7d8549df30120d164cda7cd7725bf99075a8945853d030a6cf3f8a33d2e02c96"
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
