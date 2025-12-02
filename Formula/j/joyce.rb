class Joyce < Formula
  desc "Emulates the Amstrad PCW on Unix, Windows and macOS"
  homepage "https://www.seasip.info/Unix/Joyce/index.html"
  url "https://www.seasip.info/Unix/Joyce/joyce-2.4.2.tar.gz"
  sha256 "85659a6ac9b94fdf78c28d5d8d65a4f69e7520e1c02a915b971c2754695ab82c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "20c5f21b6b676f4519154d1102c52754dd27dabdc86b315608606df1c3ba37b4"
    sha256 arm64_sequoia: "ae0fdeaa3809a10e27b240f1f29e70d158f88534129099ec6d99217486def25a"
    sha256 arm64_sonoma:  "57b24a9e0cffaf5db60282d1c187fc8d0696ea650e0516cc9c56357c6dce623d"
    sha256 sonoma:        "fb292d0294d469f5581f695956bc4c2ca6126c2fc4f138d7d2397fc4675115b7"
    sha256 arm64_linux:   "b43b277ef8c1c0cf306e87253cb9857809b5a03823fd511982745c2081b63f28"
    sha256 x86_64_linux:  "844d5e4d8fa06ff2d18adba05365c9a5378d712cfc867d89ef8087e8ef742395"
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
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    # Remove conflicting files with bundled libdsk
    %w[apriboot dskdump dskform dskid dskscan dsktrans dskutil md3serial].each { |f| rm bin/f }
    rm lib/"libdsk.a"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xjoyce --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"xjoyce", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "JOYCE will emulate a PCW 82048 (or 92048)", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
