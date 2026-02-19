class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.8.tar.gz"
  sha256 "eb872b4f0e1f0ebe59c9f7bd8c506c4204893ba6a8492de31df416f0d5170fd0"
  license "Zlib"
  revision 1
  head "https://github.com/madler/pigz.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "042145d01637ec82b2da2e4c2ef05ff1391b39c5aaafdebbe46d43f2b595404a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dfeb313ced9d0f068c33679c38a50db0a2a26a9177ffd0d6845d1320cea3879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "671f18fa88cf17e1eed437f51b85b97ef54b0d650222d3a905d60fe4399a57f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7fedaf53aad7b5d257fe1789ad82d864979a70dc6b1a2b51ca913b131c1673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d4c423ba93d711357705b6f4bd87d39c83ec4d60a94fd0ef08a2c875532eeee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9daa1d45e359ca4ff5c166c27c17803b3218ca73446e957df017614671ee9690"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert_predicate testpath/"example.gz", :file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1024k", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
