class Progress < Formula
  desc "Progress: Coreutils Progress Viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.14.tar.gz"
  sha256 "214a0d84b3ee5dde57ec9952ec9aa68ad9261fb336ef025324b344ed7ab48af1"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e6838fa54395e52684173a620b565a847ce25c1945edeb26a190702a3b36e67" => :catalina
    sha256 "a8247f7d99f2bd201810ad887d2354fa72e79f8c14d4ab896b0e60861c52b3d9" => :mojave
    sha256 "30283abf5c811af72c62e3c2467479f7373ce176e3eb6ca940039ca77cb938e0" => :high_sierra
    sha256 "cdceba6fffdaca9563a5888452a4227f7e715547a2345c5ba36ff12945e8bfd2" => :sierra
    sha256 "11217f309893e35b8be163a077f9934ce4d71e4a8ff0098e3f12751f64310925" => :el_capitan
  end

  uses_from_macos "ncurses"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    pid = fork do
      system "/bin/dd", "if=/dev/urandom", "of=foo", "bs=512", "count=1048576"
    end
    sleep 1
    begin
      assert_match "dd", shell_output("#{bin}/progress")
    ensure
      Process.kill 9, pid
      Process.wait pid
      rm "foo"
    end
  end
end
