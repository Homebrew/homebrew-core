class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-4.9.tar.gz"
  sha256 "e256a4d2fbe46f6132460833ba447e65d7f35ba9d0b265e7c4150397cc4405a2"
  license "ISC"
  revision 1
  head "https://github.com/eradman/entr.git"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a020aed45a2fc5675054d3e2a4225ae6947367da44c43eb5c6f30243c1f1e5a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "cbf5fc86b826f3dc20159380700fe9998db67e70677ea419462faf2757346caa"
    sha256 cellar: :any_skip_relocation, catalina:      "4c073f34400c6d631eac1f8636779f8fb3f36b7639817201c8258ba2ba651ceb"
    sha256 cellar: :any_skip_relocation, mojave:        "4f8f5b3b27a067c9e0220cc3f5f221b9350dcf64c668043d11a7bcd0468765bd"
  end

  # Fix v4.9 segfault on the Mac: https://github.com/eradman/entr/issues/74
  # TODO: remove in next release
  patch :DATA

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath).strip
  end
end

__END__
diff --git a/entr.c b/entr.c
index ebe535a2dc18baf1cc58db3d96a20db6822c61e7..e137919d4c11051ffa0b87691bb771f681c43b72 100644
--- a/entr.c
+++ b/entr.c
@@ -164,6 +164,8 @@ main(int argc, char *argv[]) {
 	if (open_max == 0)
 		open_max = 65536;
 #elif defined(_MACOS_PORT)
+	if (getrlimit(RLIMIT_NOFILE, &rl) == -1)
+		err(1, "getrlimit");
 	/* guard against unrealistic replies */
 	open_max = min(65536, (unsigned)rl.rlim_cur);
 	if (open_max == 0)
