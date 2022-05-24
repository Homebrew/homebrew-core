class Chrpath < Formula
  desc "Tool to edit the rpath in ELF binaries"
  homepage "https://tracker.debian.org/pkg/chrpath"
  url "https://deb.debian.org/debian/pool/main/c/chrpath/chrpath_0.16.orig.tar.gz"
  sha256 "bb0d4c54bac2990e1bdf8132f2c9477ae752859d523e141e72b3b11a12c26e7b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00a03fa6ee632a4c0dbba7e0b581501b3e6118fd1cc6cfe1c0e6f53b900dca68"
  end

  depends_on :linux

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match "chrpath version #{version}", shell_output("#{bin}/chrpath -v")
    (testpath/"test.c").write "int main(){return 0;}"
    system ENV.cc, "test.c", "-Wl,-rpath,/usr/local/lib"
    assert_match "a.out: RPATH=/usr/local/lib", shell_output("#{bin}/chrpath a.out")
    assert_match "a.out: new RPATH: /usr/lib/", shell_output("#{bin}/chrpath -r /usr/lib/ a.out")
    assert_match "a.out: RPATH=/usr/lib/",      shell_output("#{bin}/chrpath a.out")
    system "#{bin}/chrpath", "-d", "a.out"
    assert_match "a.out: no rpath or runpath tag found.", shell_output("#{bin}/chrpath a.out", 2)
  end
end
