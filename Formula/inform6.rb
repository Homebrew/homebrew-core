class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.36-r1.tar.gz"
  version "6.36-r1"
  sha256 "25aa95b10982bbeace4e33ed9452b01bef4a29cf952c4ff50cbd93f5c42a47c1"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30f3169f13d110a9b4e91c3b5e13d4718fe5f8109a9f4c8a4aff88eebde0c15c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4098f22b6db124a96dc0c3edaf7cd7525dbbdc1da0b6b713a0f23f059a401f25"
    sha256 cellar: :any_skip_relocation, monterey:       "70448796f87f81162b05f950ea894412b0738d8e4bd22cb3072e014ee4c0999f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe3510088977e60df1cd3907641cd7860e9b68909fae95247f66c7b723778535"
    sha256 cellar: :any_skip_relocation, catalina:       "e5e16cdc74c99d7bce63fb8ac5444cbe26a76e334cf62dddd2b7b5fdecaa8538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91a38c69c935c407882450728f81bf7e21889f27aacd41ae3df5012e878832fb"
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
