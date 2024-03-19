class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240309.tar.gz"
  sha256 "4336c5e32a7a4026cb731c7a439d3260129e4cbc0f71024cf3dceac1c5814480"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72149b50354383458f5cdd1c79292e22f907e705ab48b0dee7c32b0fba26f43c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fc180ef854d07bc64800f50e438160e0f9c2088274bd590470ec39882dd1a54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6aae60b8b96f509552bd26bfd3f43bfa92fbee39b8e84cb51df92b26e7aa4c3"
    sha256                               sonoma:         "d24fa76547f953c61efb0d8c72723461abbd74b914a0ab5212d98ce287f88987"
    sha256                               ventura:        "c9e6ef96724ae8ff30957f72a7bb7b57d853272ddf2ce53d5fdf6f0ae3f80114"
    sha256                               monterey:       "99faa12855ed016313bccdab6fe576bead3e663c657506b7dcf5f0a5c270bbf5"
    sha256                               x86_64_linux:   "072c2a087e20940c791204175e152c30cf5983db58d8d7630be9e148efc473e3"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
