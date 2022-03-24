class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20210108.tgz"
  sha256 "567ca0e803bfd57c41686f3b1a7df4ee4cec3c2d57ad4f8e5cda247fc5735269"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ef362f6583a9a5779f8fb0a5237cc554615161d4f7f9fd5b054e0a59b51d917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c7332e45d68c7c34e04b36935495e8e189944442650379f2c920757f2b210b7"
    sha256 cellar: :any_skip_relocation, monterey:       "43a5d452995b4befa7498697435d30594bf4aa619750ef9f60d8192a35332ee0"
    sha256 cellar: :any_skip_relocation, big_sur:        "447070d7c227cdb2e5c8df360c8ea31c8f9fa89b39e2092a3a888a40caedb523"
    sha256 cellar: :any_skip_relocation, catalina:       "1f2a9da46190bde2855e3bdc5d430302c831e3ff0eb3e3c34f8754bbe73744da"
    sha256 cellar: :any_skip_relocation, mojave:         "1872e08cd8d7addb8459865d451622d05ed4f4fc2f91e3a6f144ba1fe483b27a"
  end

  # Build succeeds with system gcc (5.4.0) but seems to segfault at runtime.
  # Unclear whether this is an issue with the compiler itself or the libc++ runtime.
  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
