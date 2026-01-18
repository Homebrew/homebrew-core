class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "https://www.leonerd.org.uk/code/libtermkey/"
  url "https://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz"
  sha256 "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libtermkey[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "3f3b0155836ea23f051a5b94c6129d6ed1927f9daea716e1f72634470c7557b7"
    sha256 cellar: :any,                 arm64_sequoia:  "8c57ec64138dc53f48eb64c8dcfb06c3da89bd5cf9cdd2c6187adb2d7b09c3d4"
    sha256 cellar: :any,                 arm64_sonoma:   "e11c08c04ff726e2bd6cd5138bc739e0caa1f64f35e79aa640916a5e312c877c"
    sha256 cellar: :any,                 arm64_ventura:  "7d8785550b878770b207750a28a857906ddcca4dd23ad01d2c1c342adca32e2a"
    sha256 cellar: :any,                 arm64_monterey: "7ffaeabbe372926ca45094684424add804cb1a8140c88a19115e7e41e02dedc9"
    sha256 cellar: :any,                 arm64_big_sur:  "fc0c8e944f2a0e93500e6b93823b685aa085badbf298cf933ef2be6c615ab9a1"
    sha256 cellar: :any,                 sonoma:         "507c7f87470c6d1b1135738fef8cc8776d28feb2fe00d40083a316d139bbbcb1"
    sha256 cellar: :any,                 ventura:        "78d8398b5a79c26bf5b6cb85d71293309ed5533abd6de7ab0ff5d0b77bbfd4d6"
    sha256 cellar: :any,                 monterey:       "4acf8f693e3ca76abb35a77f32edd5f54dbe47419fa690a9c32c396536a30b00"
    sha256 cellar: :any,                 big_sur:        "4a463c5f31b1748ce885716a2f709f3ff1791725bb67e71bd9b44080148d6ff2"
    sha256 cellar: :any,                 catalina:       "d011f1ac8c14c605e8614cac5328a8b41f0a8f5775d8919104d1495acdc9e135"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "34ca685938466b3866c5a986b40dfb762c19fbd0a050f1c5c61b4884f7446a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359504c1b88e079ed34f73484c6196c5e5a2f6ca402088cbb7a537177cc22f93"
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "unibilium"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "glib" => :build
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
  test do
    (testpath/"test.c").write <<~C
      #include <termkey.h>
      #include <stdio.h>

      int main() {
        TermKey *tk = termkey_new(0, 0);
        if (tk == NULL) {
          fprintf(stderr, "Failed to initialize libtermkey\\n");
          return 1;
        }
        termkey_destroy(tk);
        printf("libtermkey initialized and destroyed successfully\\n");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltermkey", "-I#{include}"
    assert_match "libtermkey initialized and destroyed successfully", shell_output("./test")
  end
end
