class Progress < Formula
  desc "Progress: Coreutils Progress Viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.13.1.tar.gz"
  sha256 "064c95e8b93893dbf4b4b8152290cbb3b0c005eda0cae500353561048c9939a5"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any_skip_relocation
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
