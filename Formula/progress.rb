class Progress < Formula
  desc "Progress: Coreutils Progress Viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.14.tar.gz"
  sha256 "214a0d84b3ee5dde57ec9952ec9aa68ad9261fb336ef025324b344ed7ab48af1"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2efd9539e80fa903348eb1c6c7448351e1447c195b430fa7054e5f2a07c96e3f" => :high_sierra
    sha256 "c04bdc66a7781fea19a127c30ad986de002bad27f7a198bdc892871a0fed78dc" => :sierra
    sha256 "25a02d55c08c5bc17fa3830f577bbdc7320db434a499c95e5d6822cddccafdda" => :el_capitan
    sha256 "0227e47f3d9614b1d67422d22f15321e5dfb2a078feee89dcff30ec0bffd2adc" => :yosemite
  end

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
