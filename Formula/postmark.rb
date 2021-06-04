class Postmark < Formula
  desc "File system benchmark from NetApp"
  homepage "https://packages.debian.org/sid/postmark"
  url "https://deb.debian.org/debian/pool/main/p/postmark/postmark_1.53.orig.tar.gz"
  sha256 "8a88fd322e1c5f0772df759de73c42aa055b1cd36cbba4ce6ee610ac5a3c47d3"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "3c588393d3075f1943d481a1db03af3835997d104357108f0812bc4ade44686f"
    sha256 cellar: :any_skip_relocation, mojave:      "df5e68b280b40151c28cefb46a97605044af5c0e879f73a6d972676007aeffe6"
    sha256 cellar: :any_skip_relocation, high_sierra: "0e7f59c257967fd72381d86fca353c88f4af9d4843c0aa9e3eb4f606a6619fc4"
    sha256 cellar: :any_skip_relocation, sierra:      "9d702b7bc49f646fd1623b316fd62c84ee6413e035a81e95866b0ca7240f100e"
    sha256 cellar: :any_skip_relocation, el_capitan:  "784b46fe9883d27d347a44da73413ccf5c589088c0b57da577ebc1c79e64e1e6"
    sha256 cellar: :any_skip_relocation, yosemite:    "7fb38c3960e124a836cdc48650fd5f4d1fc446897b590e0dd6b6b6b5cbdec522"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system ENV.cc, "-o", "postmark", "postmark-#{version}.c"
    bin.install "postmark"
    man1.install "postmark.1"
  end

  test do
    (testpath/"config").write <<~EOS
      set transactions 50
      set location #{testpath}
      run
    EOS

    output = pipe_output("#{bin}/postmark #{testpath}/config")
    assert_match "(50 per second)", output
  end
end
