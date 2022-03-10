class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.36-r1.tar.gz"
  version "6.36-r1"
  sha256 "25aa95b10982bbeace4e33ed9452b01bef4a29cf952c4ff50cbd93f5c42a47c1"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87a9ebbe2e53f442b67bbf92a08a90ab256afc382739a9571f2a5a1d2a87abb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b865b7bb10a0c39128287d21e780670744fb355dac98a1556fd957fd3a811250"
    sha256 cellar: :any_skip_relocation, monterey:       "8d2403a74d5cd2b64e3fe490564f4f5b44a2b3d5fc6d1519bdca5cbccb4b7ce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f64149f2294a826a37443b9ec8483cb638ccabc7f857e03d9d8806bbc40a7c13"
    sha256 cellar: :any_skip_relocation, catalina:       "7b7c896e5770b09a8cc63dbc69366d9436e42f9f0e9d7ee6836b5f8c14c9c2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d18942e3a310db80139f4ec408a3ac08a8a9c7e7f2ef64cc328c7e6c85e50d1f"
  end

  resource "homebrew-test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("homebrew-test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
