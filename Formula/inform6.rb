class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r8.tar.gz"
  version "6.35-r8"
  sha256 "a1babb9ac9fc68fc397905ba713f0651e16cade77f828d692f8f91195daa0f57"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a529d1a4898116c771b4eb639bf24fb427e8f7fec693f731530d4a725797fea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eee2ef5d81270ff44d2e5ed5f540fdfb451e94d476f3f2b78766467e3a4f373c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5d3ab948afa8acd41b896a8a4222f0e491cdfbd7b3ebe3637a1b726ff4a2ff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4753d1d1e49190418a1f8cd19f56d4c457a4cb8e8c8eff0caec0aebfec4a6d93"
    sha256 cellar: :any_skip_relocation, catalina:       "8c72db0741f63538c8a88a55a72707188d4ca184a615c0b2102de15f71e943be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35dbd34f4486953ab256b8357005637f8dabb50a41d2f39b51014b619a7d2231"
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
