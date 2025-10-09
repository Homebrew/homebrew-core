class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.49.1.tar.gz"
  sha256 "e67dec5e347fbfd2563f334ede024aef1820f2fd5107091612a58a2d61308799"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b8967d154c167fdb95994a28b7dfe6a04f439a0ccc4a12ed951fbe3e6570ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd0760d2711079ed3ab810abe3ad4957e37d9407dd2ab4eaf7c546aecef46c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d425d89b449f6f742f3ed002fc8b2c59dc8d1437541bdf974a5fae42e0bd8fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c1979a45a0e0f384e8412ad7e322ceff6ccd850d33fc1d1fd3ac07a010ccaab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28672f1071f9565ccd8444de3ef86c9ef979c5b0474ddf0d8a485cee42a70d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6688384c810444964082eb9098b868edb59bf9c2b98f48a31d27fef01923c4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
