class Joyce < Formula
  desc "Emulates the Amstrad PCW on Unix, Windows and macOS"
  homepage "https://www.seasip.info/Unix/Joyce/index.html"
  url "https://www.seasip.info/Unix/Joyce/joyce-2.4.2.tar.gz"
  sha256 "85659a6ac9b94fdf78c28d5d8d65a4f69e7520e1c02a915b971c2754695ab82c"
  license "GPL-2.0-or-later"

  # Upstream indicates stable releases with an even-numbered minor (e.g., 1.2.3)
  # and the regex below only matches these versions as a way of avoiding the
  # development tarball on the download page.
  livecheck do
    url "https://www.seasip.info/Unix/Joyce/download.html"
    regex(/href=.*?joyce[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "d19ab6f1ea382072a8b00a2aeff4c25f8b8b2a3150c4af3a6c2f41ff66a90150"
    sha256 arm64_tahoe:       "e2158169899c44fdff0bf9b3211bb33383817412c2ede428db4606f04650b0eb"
    sha256 arm64_sequoia:     "dc481968eb3c1cffab85fd94f15c01dac8172ca23b99812088fd9d8626b6d9e7"
    sha256 arm64_linux:       "020de32fa5e61a0dbf45d07ee93894ac37e657586b57aaa21e53b3bb0dbb7efd"
    sha256 x86_64_linux:      "2a18b56e9f7a2663c9f6f4dcfccdec42d3d89c303a7aaaf52d696cbe9d9c2a70"
  end

  depends_on "libdsk"
  depends_on "libpng"
  depends_on "sdl12-compat"

  uses_from_macos "libxml2"

  def install
    # At the moment Joyces uses and bundles libdsk-1.5.x (dev)
    # while homebrew provides libdsk-1.4.x (stable) so we cannot
    # use the system's libdsk and we need to remove/not link
    # conflicting files.
    # system "./configure", "--disable-silent-rules", "--with-system-libdsk", *args
    args = %w[
      --disable-sdltest
      --disable-silent-rules
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Remove conflicting files with bundled libdsk
    %w[apriboot dskdump dskform dskid dskscan dsktrans dskutil md3serial].each { |f| rm bin/f }
    rm lib/"libdsk.a"
  end

  test do
    assert_match "PCW / IBM 180k", shell_output("#{bin}/dskconv -formats")
    return if OS.mac? # unable to run xjoyce within macOS sandbox

    assert_match version.to_s, shell_output("#{bin}/xjoyce --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"xjoyce", [:out, :err] => output_log.to_s
    begin
      sleep 2
      assert_match "JOYCE will emulate a PCW 82048 (or 92048)", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
