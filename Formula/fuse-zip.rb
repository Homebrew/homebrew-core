class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.1.tar.gz"
  sha256 "7dac61c3f27f9041545ab1a22bb772ea282ed2dea25a0220dcecfa6801b5b121"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "f368e76466c6a341d2f08876d9c5c7d523db0cc84b1a4641457d02bc796fc4c3" => :catalina
    sha256 "8aa19497fa708322ec386d9578ba0d323620bc4c26a9d257f9cbd25140aac908" => :mojave
    sha256 "ffedaf1ee44691c491f2b0ab134cd97263ce27bb9ec110874c23af4bdcfd18cb" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on :osxfuse

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
