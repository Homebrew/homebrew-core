class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.0.tar.gz"
  sha256 "87758fd6bc4bc3db32d6a557b84db28fa527be2102ecf9c465cb5a0393af428f"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eedcd8adb56807b193f8925efca20d9933a62d95c625c7c3894cc3e9d3b901c9" => :big_sur
    sha256 "93114288238bfe25c8f3329a551370db61bfe69657c973c17f7055472a5356c0" => :arm64_big_sur
    sha256 "573ab7b3cf5573926bdfe98a23f441fba62631bb300ab86b1fbd04404b59bd6a" => :catalina
    sha256 "29aa8bfa211a22de8348c3dc440491633c223b4ab7c0323c31d8a0134eb4fe6b" => :mojave
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
