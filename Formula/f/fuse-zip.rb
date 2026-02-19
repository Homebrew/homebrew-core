class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.2.tar.gz"
  sha256 "3dd0be005677442f1fd9769a02dfc0b4fcdd39eb167e5697db2f14f4fee58915"
  license "GPL-3.0-or-later"
  head "https://bitbucket.org/agalanin/fuse-zip.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b9ea1815940249c680e5f6524a9da80d600f3dc8a1d40d89dec4b49de64b4d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e87dbeae5e24ded35705e704caf66faec39dc8971742ff43c7a45882ef6e349"
  end

  depends_on "pkgconf" => :build
  depends_on "libfuse@2"
  depends_on "libzip"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
