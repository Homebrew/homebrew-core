class Progress < Formula
  desc "Progress: Coreutils Progress Viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.13.tar.gz"
  sha256 "160cb6156a0b8df32a3944f3dcecba956ae3e5579e91d53c9d7417bc4956718c"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f7422b950b3dfb9d2fe7be3380cec810321bf5fe490b5ddb225b29580be891d" => :sierra
    sha256 "92fdddbc22594566e79458fa3b4a63bee3f4bcdd569b88827837e8a18d6eaf3a" => :el_capitan
    sha256 "35741d1986bd5df66ecec5603af82aefa0f1c5728fd6481780a1b77875edc4ad" => :yosemite
    sha256 "965f987b35a069855eb9d43068c05f284272211ebfaaf1e3197386974d6da3a6" => :mavericks
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
