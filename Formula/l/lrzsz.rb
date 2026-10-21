class Lrzsz < Formula
  desc "Tools for zmodem/xmodem/ymodem file transfer"
  homepage "https://www.ohse.de/uwe/software/lrzsz.html"
  url "https://www.ohse.de/uwe/releases/lrzsz-0.13.1.tar.gz"
  sha256 "112f91059fbd118e016d800c1a5c5a1702e965d8b9bfbda6015e44e20bfb93c9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lrzsz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "204bbbdada772172509824967c5690b1f0b84f6a799da6334d1af7c554653acb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd00be92ae2f7349032af8fb8016b6c219d3a0e77197a4e5a7b4f9b8772ca021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ceb366f9174c838545587c7f289e5de7f658620a5e418e15afaaaec29f329c9"
    sha256 cellar: :any,                 arm64_linux:       "305a9e4b3ebe0077785dfee8478a1d0026874cdc9937cafd6d9092636d7a89aa"
    sha256 cellar: :any,                 x86_64_linux:      "5117d768a062a72f82de07fb1508ae290af22b371c08c1007bc2a90e83d3a5c5"
  end

  conflicts_with "lrzip", because: "both install `lrz` binaries"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-nls"
    system "make"

    # there's a bug in lrzsz when using custom --prefix
    # must install the binaries manually first
    bin.install "src/lrz", "src/lsz"

    system "make", "install"
    bin.install_symlink "lrz" => "rz", "lsz" => "sz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lrb --help 2>&1")
  end
end
