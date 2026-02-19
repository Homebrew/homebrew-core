class Cgit < Formula
  desc "Hyperfast web frontend for Git repositories written in C"
  homepage "https://git.zx2c4.com/cgit/"
  url "https://git.zx2c4.com/cgit/snapshot/cgit-1.2.3.tar.xz"
  sha256 "5a5f12d2f66bd3629c8bc103ec8ec2301b292e97155d30a9a61884ea414a6da4"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://git.zx2c4.com/cgit/refs/tags"
    regex(/href=.*?cgit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "be548ed68df6c0f5be5a264f52cd1a5625e34b562ff27086b95b222339179b18"
    sha256 arm64_sequoia: "ed3616461e84443db121307ec689ead2f13259075e5b78d5ba9c57e492a8c1e0"
    sha256 arm64_sonoma:  "2c45ae870e93c74f7c46d9ae43ff238d113c134357c1dadb7f16f272a099f902"
    sha256 sonoma:        "26d6321985ace42f306ee4bb887332e3cdf405dc59b47d1b0309e5620e1b2821"
    sha256 arm64_linux:   "23411d564170f93eb3dfd7023c2927ea145ec740c5f1a5e02ea2c32f06676f4c"
    sha256 x86_64_linux:  "45eee7a055629b3121032d6df36ba9ec244bb0143411f63ea2b7cd2fc6966325"
  end

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "openssl@3" => :build # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  # git version is mandated by cgit: see GIT_VER variable in Makefile
  # https://git.zx2c4.com/cgit/tree/Makefile?h=v1.2#n17
  resource "git" do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.25.1.tar.gz"
    sha256 "4999ae0ee6cc7dfb280d7051e39a82a5630b00c1d8cd54890f07b4b7193d25aa"
  end

  # cgit 1.2.2+ needs memrchr, for which macOS provides no implementation
  # https://lists.zx2c4.com/pipermail/cgit/2020-August/004510.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/cgit/memrchr-impl.patch"
    sha256 "3ab5044db3001b411b58309d70f00b0dee54df991ebc66da9406711ed4007f0f"
  end

  def install
    resource("git").stage(buildpath/"git")
    system "make", "prefix=#{prefix}",
                   "CGIT_SCRIPT_PATH=#{pkgshare}",
                   "CGIT_DATA_PATH=#{var}/www/htdocs/cgit",
                   "CGIT_CONFIG=#{etc}/cgitrc",
                   "CACHE_ROOT=#{var}/cache/cgit",
                   "install"
  end

  test do
    (testpath/"cgitrc").write <<~EOS
      repo.url=test
      repo.path=#{testpath}
      repo.desc=the master foo repository
      repo.owner=fooman@example.com
    EOS

    ENV["CGIT_CONFIG"] = testpath/"cgitrc"
    # no "Status" line means 200
    refute_match(/Status: .+/, shell_output("#{pkgshare}/cgit.cgi"))
  end
end
