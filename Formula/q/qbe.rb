class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "https://c9x.me/compile/release/qbe-1.2.tar.xz"
  sha256 "a6d50eb952525a234bf76ba151861f73b7a382ac952d985f2b9af1df5368225d"
  license "MIT"
  head "git://c9x.me/qbe.git", branch: "master"

  livecheck do
    url "https://c9x.me/compile/releases.html"
    regex(/href=.*?qbe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c41fd6b7adfea92b2b90f14ff60a584d471f1b79d343949bcb4e42ff0b55bbc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971805c559bb8ae51a1c900d90f21530bdc47752b53f140c8ba8f4a66c63dc55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85df90e1fa6920fb08e7b1a082927d655e7f051cf2078dda1137a032249b80ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "59e80cb7758faa82c7f4b2541deef61f12fae3186843c869cb2a0856eef4d268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b6dfaf0ead4216cfe8d0f328fc30e5f69f5d827f03c9a18b8e576eb3027ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab98f6cfc7bc3c366c0aa92f785940bb8de5b2e0384495d6f1752629b4e9acf"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"main.ssa").write <<~EOS
      function w $add(w %a, w %b) {        # Define a function add
      @start
        %c =w add %a, %b                   # Adds the 2 arguments
        ret %c                             # Return the result
      }
      export function w $main() {          # Main function
      @start
        %r =w call $add(w 1, w 1)          # Call add(1, 1)
        call $printf(l $fmt, ..., w %r)    # Show the result
        ret 0
      }
      data $fmt = { b "One and one make %d!\n", b 0 }
    EOS

    system bin/"qbe", "-o", "out.s", "main.ssa"
    assert_path_exists testpath/"out.s"
  end
end
