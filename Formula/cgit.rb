class Cgit < Formula
  desc "Hyperfast web frontend for Git repositories written in C"
  homepage "https://git.zx2c4.com/cgit/"
  url "https://git.zx2c4.com/cgit/snapshot/cgit-1.2.3.tar.xz"
  sha256 "5a5f12d2f66bd3629c8bc103ec8ec2301b292e97155d30a9a61884ea414a6da4"
  license "GPL-2.0-only"

  livecheck do
    url "https://git.zx2c4.com/cgit/refs/tags"
    regex(/href=.*?cgit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "bfdbfab0f980e7e67524d20a06eab7f1bb2cf788d32c2d20f9fd7e690e6d2689"
    sha256 arm64_big_sur:  "1d94a449229b9550a5d76b9d1f0140ea6b267fcd982539d6537fce21447aae12"
    sha256 monterey:       "bba8ad34b9bf164125a5abf7f7bfbbe93414ff4d0635b47cf1f781d4fdc9efe5"
    sha256 big_sur:        "43d5a3249276dc89f9b8730b775fab358f9a04adac63fc18dc1257cecb0de2a8"
    sha256 catalina:       "c5317498aefba5a04343b14929249e42a9ecc1c5da227ae06728102418bf5e49"
    sha256 mojave:         "261aa49e87d8d4147b0ec838e22d6149f0aa41ee27751df15277b1cdb1df8bd3"
    sha256 x86_64_linux:   "27e5543ed8c84782d48241262c483a0bec68f27fa09534ff616cda09bfec7098"
  end

  depends_on "gettext"
  depends_on "openssl@1.1"

  # git version is mandated by cgit: see GIT_VER variable in Makefile
  # https://git.zx2c4.com/cgit/tree/Makefile?h=v1.2#n17
  resource "git" do
    url "https://www.kernel.org/pub/software/scm/git/git-2.25.1.tar.gz"
    sha256 "4999ae0ee6cc7dfb280d7051e39a82a5630b00c1d8cd54890f07b4b7193d25aa"
  end

  # cgit 1.2.2+ needs memrchr, for which macOS provides no implementation
  # https://lists.zx2c4.com/pipermail/cgit/2020-August/004510.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5decb544ec505d0868ef79f03707fafb0e85e47c/cgit/memrchr-impl.patch"
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
