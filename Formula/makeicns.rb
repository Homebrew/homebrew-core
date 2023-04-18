class Makeicns < Formula
  desc "Create icns files from the command-line"
  homepage "http://www.amnoid.de/icns/makeicns.html"
  url "https://distfiles.macports.org/makeicns/makeicns-1.4.10a.tar.bz2"
  sha256 "10e44b8d84cb33ed8d92b9c2cfa42f46514586d2ec11ae9832683b69996ddeb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff65a9bd43bcbd780c508dd291ee72c386cee8540fd19182ef9c11a553ba62c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad8a9c2fb8884474a5b7b8bc0a2dcb1b0e55b19427a5f49b112b4c2879b1de4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad6aa042b2648b49a2be3b77324845be6121f10efd13c4be4c543024f9a8cecc"
    sha256 cellar: :any_skip_relocation, ventura:        "3be93d7fe187c348c6bbece447025b8774e178990c58b6b7c56ec7c130588566"
    sha256 cellar: :any_skip_relocation, monterey:       "70c4f25edb72a10186308dff6f39a721c203f7f237faa3d390b63390be1db0db"
    sha256 cellar: :any_skip_relocation, big_sur:        "25bf3bcc571e185ad08b148a3ee9ca54fc6eb32c638083280ae2f16a06e87910"
    sha256 cellar: :any_skip_relocation, catalina:       "c2a5afff3eee709316951ad70c8244fe5c628ae98fdb2e15ea607c7638733d63"
    sha256 cellar: :any_skip_relocation, mojave:         "16d2135a49e22ffe920567c7ac382d5f706ef7ce5de377750553a0e59414819a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c40907f2d30603bdfe8402e90cbb35209b46cee1e7967d0ab06c21d5d7935eb8"
    sha256 cellar: :any_skip_relocation, sierra:         "3a673790c42724f75b905713e269f8bfa3e54bb64fde48130164c68b5656c871"
    sha256 cellar: :any_skip_relocation, el_capitan:     "96f91bccf728f040931c2816156a7c5de739ae91e63191795cd108d0a46370ac"
  end

  depends_on :macos

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e59da9d/makeicns/patch-IconFamily.m.diff"
    sha256 "f5ddbf6a688d6f153cf6fc2e15e75309adaf61677ab423cb67351e4fbb26066e"
  end

  def install
    system "make"
    bin.install "makeicns"
  end

  test do
    system bin/"makeicns", "-in", test_fixtures("test.png"),
           "-out", testpath/"test.icns"
    assert_predicate testpath/"test.icns", :exist?
  end
end
