class Fcp < Formula
  desc "Significantly faster alternative to the classic Unix cp(1) command"
  homepage "https://github.com/Svetlitski/fcp/"
  url "https://github.com/Svetlitski/fcp/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e835d014849f5a3431a0798bcac02332915084bf4f4070fb1c6914b1865295f2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3ecde8d0f0c52f74dd8b0b7eb77f87d9e17a3da375da6a5c0849de5c7e68fc92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e7d88353ca2875a9db0c92e402a0b6e3872dc6d09ffa332524238d50b1535f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5c7dd64a671f3be2b628cddb46a09bd5f7584d52b6b64ed0a1dd67f56b97564"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b0e528ead3af345955bcd02b2793a037e0cf8593b2b94c834ef27eeab2785e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4763ef14ff83f2fbea8fa7ed18a06cf3e8e1551524d41efd3cbc860724d1593d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cff2c5b5be26264b89298a8387318b8dea3e005f8d66a6d09af4277ffe12e8c"
    sha256 cellar: :any_skip_relocation, ventura:        "60b50e242a72308c45294e69ce7e49722d2de21e82897fef7bead52809056cb1"
    sha256 cellar: :any_skip_relocation, monterey:       "cbae19b5f16fac050195c57c77c40dcf6d5737d0ed8dec5d7876274456e9581e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b91b77aba18ae0a1806de04a8543dd7c6234f73936bd9a6653ed8052c31d1d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4dc5c096786f4581a3799e890ac3c98c86d32a9ef59f57ca525a4a717f4eab"
  end

  depends_on "rust" => :build

  # rust 1.80 build patch, upstream pr ref, https://github.com/Svetlitski/fcp/pull/42
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/fcp/rust-1.80.patch"
    sha256 "cd9057498c939c9a9999408128b0561a4a7c0bc618b0426216c7fe94e00a99da"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"src.old").write "Hello world!"
    system bin/"fcp", "src.old", "dest.txt"
    assert_equal (testpath/"src.old").read, (testpath/"dest.txt").read

    (testpath/"src.new").write "Hello Homebrew!"
    system bin/"fcp", "src.new", "dest.txt"
    assert_equal (testpath/"src.new").read, (testpath/"dest.txt").read

    ["foo", "bar", "baz"].each { |f| (testpath/f).write f }
    (testpath/"dest_dir").mkdir
    system bin/"fcp", "foo", "bar", "baz", "dest_dir/"
    assert_equal (testpath/"foo").read, (testpath/"dest_dir/foo").read
    assert_equal (testpath/"bar").read, (testpath/"dest_dir/bar").read
    assert_equal (testpath/"baz").read, (testpath/"dest_dir/baz").read
  end
end
