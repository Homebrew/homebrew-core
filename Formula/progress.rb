class Progress < Formula
  desc "Progress: Coreutils Progress Viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.13.tar.gz"
  sha256 "160cb6156a0b8df32a3944f3dcecba956ae3e5579e91d53c9d7417bc4956718c"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "966124c6d66ed029895b1f2f3a9548e9d100287676cc31630e7179eec0009728" => :el_capitan
    sha256 "003f1a3ba9356bfd68149d9ae6f57e4e81bb0d7def7dc9d4419338275f2e6af1" => :yosemite
    sha256 "9bb9bb6343e1d886f98e9ab94f2dc9391c800151bae49b27f87397319c69d730" => :mavericks
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
