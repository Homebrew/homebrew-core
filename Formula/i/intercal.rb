class Intercal < Formula
  desc "Esoteric, parody programming language"
  homepage "http://catb.org/~esr/intercal/"
  license "GPL-2.0-or-later"

  stable do
    url "http://catb.org/~esr/intercal/intercal-0.31.tar.gz"
    sha256 "93d842b81ecdc82b352beb463fbf688749b0c04445388a999667e1958bba4ffc"

    # Backport fix for GCC 10 and newer
    patch do
      url "https://gitlab.com/esr/intercal/-/commit/f33a8f3a96e955a6eb3e8db850d0edac44c22176.diff"
      sha256 "2cd1be13f779a0fd93aa3c50e1dbf62596b81727c539674d872b4e912ad62a55"
    end
  end

  # The latest version tags in the Git repository are `0.31` (2019-06-12) and
  # `0.30` (2015-04-02) but there are older versions like `1.27` (2010-08-25)
  # and `1.26` (2010-08-25). These two older 1.x releases are wrongly treated
  # as newer but the GitLab project doesn't do releases, so we can only
  # reference the tags. We work around this by restricting matching to 0.x
  # releases for now. If the major version reaches 1.x in the future, this
  # check will also need to be updated.
  livecheck do
    url :head
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 sonoma:       "bdbcb6b6741a84e30ab923c62dc0dbced0348ba9c35b95f9441bdc4bb821130a"
    sha256 ventura:      "996598c6c8145f0a45dac7109aa3cb39b5854396b58c3b7ab75c784844160877"
    sha256 monterey:     "a691470666ee0f15af22265be65eda2757fabd8f6fbc5fa8341f8c3059749d34"
    sha256 big_sur:      "487fc70071a54c09cccdbba0284db23c156983b76416a4b4c03f44130531213c"
    sha256 catalina:     "a2c1673fbed3d331e725694196acf9ea4cd6bc6df3b86568af3e67ee90d70b30"
    sha256 arm64_linux:  "dcf9671a1cd68f29ad22ed2ea028a790f03cd0b794a4156d3e958794dec68052"
    sha256 x86_64_linux: "31105eaa4a4800c562060caa8fa7c241b946c8dca2e92f0b2e101c34830787e8"
  end

  head do
    url "https://gitlab.com/esr/intercal.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on arch: :x86_64 # test fails on arm64

    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make `depends_on :linux` when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  def install
    if build.head?
      cd "buildaux" do
        system "./regenerate-build-system.sh"
      end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (etc/"intercal").install Dir["etc/*"]
    pkgshare.install "pit"
  end

  test do
    (testpath/"lib").mkpath
    (testpath/"test").mkpath
    cp pkgshare/"pit/beer.i", "test"
    cd "test" do
      system bin/"ick", "beer.i"
      system "./beer"
    end
  end
end
