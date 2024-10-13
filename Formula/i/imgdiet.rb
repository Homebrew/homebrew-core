class Imgdiet < Formula
  desc "Optimize and resize images"
  homepage "https://git.sr.ht/~jamesponddotco/imgdiet-go"
  url "https://git.sr.ht/~jamesponddotco/imgdiet-go/archive/v0.1.2.tar.gz"
  sha256 "3f15e5453195f0657322071541b0d086eb2bf2a0e39919c54f0b29b92b3ab18c"
  license "MIT"
  head "https://git.sr.ht/~jamesponddotco/imgdiet-go", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "de0bd1adbf88ec69dac95d8bfe3c033898ae4ed0ca028a70dc72ecc6c7c0cec3"
    sha256 cellar: :any,                 arm64_sonoma:   "b27da1482b19dfef907b7641e7fcbdcf7cf410152e4d445e8bbe0b9b7f03c795"
    sha256 cellar: :any,                 arm64_ventura:  "0e0134db0d4bb1b9f51ce1807c1c833403ada6e6a0e4e316a6be6fc74097de03"
    sha256 cellar: :any,                 arm64_monterey: "bda9f00c3b2beed5f2ec9458264d5a87c4941de5c5ae9ebc4fb65cbdd73bbf07"
    sha256 cellar: :any,                 sonoma:         "19cac57891233c25c105b6994b3bf7327b1f3eb0acdbf07b9d49655d994ced62"
    sha256 cellar: :any,                 ventura:        "8eb4b38290efe03c7c11ac611cdea66a587952659cb066105bb774b3fc3e83f5"
    sha256 cellar: :any,                 monterey:       "8d5cc79d420e7578164462f03c690a35b8d51e07906d61596d7e9768361a2942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebf5cf72672670a354498734f5f3961a7a103a4859b09ee5647839adf2eb19a"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/imgdiet"
  end

  test do
    system bin/"imgdiet", "--compression", "9", test_fixtures("test.png"), testpath/"out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
