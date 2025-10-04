class InotifyTools < Formula
  desc "C library and command-line programs providing a simple interface to inotify"
  homepage "https://github.com/inotify-tools/inotify-tools"
  url "https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.25.9.0.tar.gz"
  sha256 "d33a4fd24c72c2d08893f129d724adf725b93dae96c359e4f4e9f32573cc853b"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "398790457297fce591badb0fc5315513fb73eab4757f4ff6430eff016e30124c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "12f260b16fa1d829c38b346113f590a45260f3f75fb4d701a0c4fb35e11b054c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :linux

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    touch "test.txt"
    stdin, stdout, stderr, = Open3.popen3("#{bin}/inotifywatch test.txt --timeout 2")
    stdin.close
    assert_match "Establishing watches", stderr.read
    stdout.close
    stderr.close
  end
end
