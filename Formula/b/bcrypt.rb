class Bcrypt < Formula
  desc "Cross platform file encryption utility using blowfish"
  homepage "https://bcrypt.sourceforge.net/"
  url "https://bcrypt.sourceforge.net/bcrypt-1.1.tar.gz"
  sha256 "b9c1a7c0996a305465135b90123b0c63adbb5fa7c47a24b3f347deb2696d417d"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?bcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d49aa09bacc40f805eba8376e5b444b9c7824737b8beaffea99a15b9a1fe58b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3894598a8efee061b420dcf12be46a810b27daadca63fe1938482a22cf4dd746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a344073ac49b9cc183899a1752ec62eb7d170dbe74212e26c55ce2422d46b146"
    sha256 cellar: :any_skip_relocation, sonoma:        "8810055ef8834286872f5594e8baca4f24e95f37f9a1cac9ac5523e0d2e0d4e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c456f948c8acb858f885c385b2e579e13fc583041a3d20eb12e53043287bab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa2316da920f0a6857cf2ede173897a15ae590dbfa18d48d54bb35c3a9209621"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install Utils::Gzip.compress("bcrypt.1")
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    pipe_output("#{bin}/bcrypt -r test.txt", "12345678\n12345678\n", 0)
    mv "test.txt.bfe", "test.out.txt.bfe"
    pipe_output("#{bin}/bcrypt -r test.out.txt.bfe", "12345678\n", 0)
    assert_equal File.read("test.txt"), File.read("test.out.txt")
  end
end
