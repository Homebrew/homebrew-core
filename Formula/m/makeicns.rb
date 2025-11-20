class Makeicns < Formula
  desc "Create icns files from the command-line"
  homepage "http://www.amnoid.de/icns/makeicns.html"
  url "https://distfiles.macports.org/makeicns/makeicns-1.4.10a.tar.bz2"
  sha256 "10e44b8d84cb33ed8d92b9c2cfa42f46514586d2ec11ae9832683b69996ddeb8"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "eb8af37eb2ea58296938dd61754d07854878be1869c52490796617cc6fb4e43c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "89f7fec6280f4ff185da4d6bf07ba3f30f977bf40b5316c559a8af7a83f2a08c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c13f31a5163d2ffcf745b43b76516445c2dc73b17d370c5ab6c7c601245cc0e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff65a9bd43bcbd780c508dd291ee72c386cee8540fd19182ef9c11a553ba62c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad8a9c2fb8884474a5b7b8bc0a2dcb1b0e55b19427a5f49b112b4c2879b1de4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad6aa042b2648b49a2be3b77324845be6121f10efd13c4be4c543024f9a8cecc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2054c073855fecd68bb0d674cb15d1e22d357ad2b2252fb110d2ab161e32738c"
    sha256 cellar: :any_skip_relocation, ventura:        "3be93d7fe187c348c6bbece447025b8774e178990c58b6b7c56ec7c130588566"
    sha256 cellar: :any_skip_relocation, monterey:       "70c4f25edb72a10186308dff6f39a721c203f7f237faa3d390b63390be1db0db"
    sha256 cellar: :any_skip_relocation, big_sur:        "25bf3bcc571e185ad08b148a3ee9ca54fc6eb32c638083280ae2f16a06e87910"
    sha256 cellar: :any_skip_relocation, catalina:       "c2a5afff3eee709316951ad70c8244fe5c628ae98fdb2e15ea607c7638733d63"
  end

  depends_on :macos

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/makeicns/patch-IconFamily.m.diff"
    sha256 "f5ddbf6a688d6f153cf6fc2e15e75309adaf61677ab423cb67351e4fbb26066e"
  end

  def install
    system "make"
    bin.install "makeicns"
  end

  test do
    system bin/"makeicns", "-in", test_fixtures("test.png"),
           "-out", testpath/"test.icns"
    assert_path_exists testpath/"test.icns"
  end
end
