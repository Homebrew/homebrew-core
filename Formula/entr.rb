class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-4.8.tar.gz"
  sha256 "f05555cd745b7dc67b61a98cf79971125b7e43931a5772d5bce2d891327425ae"
  license "ISC"
  head "https://github.com/eradman/entr.git"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c565a40ecea43d1a11359c89faae83ddf72f8333e2502c9484c889ef581b6246"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c766358f913ef78bb956e50aef6e5b7d742b53fdf764a57feaaa9c35c0a6fa4"
    sha256 cellar: :any_skip_relocation, catalina:      "8325c4a45a914f504b4097cb02d4575dcd62a73b44b79592f679b2abcd83b4a8"
    sha256 cellar: :any_skip_relocation, mojave:        "133c9d70c130b848c948829b1e43d4325de4f7da32c3134987ff616242118c60"
  end

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
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
