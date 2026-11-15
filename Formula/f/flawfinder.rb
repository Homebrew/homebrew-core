class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://dwheeler.com/flawfinder/"
  url "https://dwheeler.com/flawfinder/flawfinder-2.0.20.tar.gz"
  sha256 "9d732a4e0fef1cd4eaeefd4a0093f183c5981f6c843711ceae6a63419404996b"
  license "GPL-2.0-or-later"
  head "https://github.com/david-a-wheeler/flawfinder.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "aa87731edffcda8ecab4d8338635f5dff27567eab1bea3ec4e2c8f56f5153d9b"
  end

  uses_from_macos "python"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      int demo(char *a, char *b) {
        strcpy(a, "\n");
        strcpy(a, gettext("Hello there"));
      }
    C
    assert_match("Hits = 2\n", shell_output("#{bin}/flawfinder test.c"))
  end
end
