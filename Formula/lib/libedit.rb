class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20250104-3.1.tar.gz"
  version "20250104-3.1"
  sha256 "23792701694550a53720630cd1cd6167101b5773adddcb4104f7345b73a568ac"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cea11c2d6de1a8a2cc22c08a71ab24aa2909793c65496b01c054b31973953229"
    sha256 cellar: :any,                 arm64_sonoma:  "f8a921a04eb8a7a678646017c40f6ff7be5149bacde10e5df26d17623bc8fc71"
    sha256 cellar: :any,                 arm64_ventura: "4b176c32e18719e5ec303bde3f4b64312fcd9f7a1e2426df1962290864ebedf9"
    sha256 cellar: :any,                 sonoma:        "eed32540db79d8c02b3dd9076459f08a4f5660cfd6c54cb0db55b76379470126"
    sha256 cellar: :any,                 ventura:       "1a5446ca536e448c52101e281a8dcbac549dd2306090972337a37bce022d6e4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4845c0d7d9cea3199da9eb29bea21a0d62b7f4e8322ae90acaeb4a2dc39f295f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de065ef66904f7758361d623fc96cbc5226663d919b3d6524f9b46bf3153692"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
