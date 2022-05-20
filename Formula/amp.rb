class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.6.2.tar.gz"
  sha256 "9279efcecdb743b8987fbedf281f569d84eaf42a0eee556c3447f3dc9c9dfe3b"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/jmacdonald/amp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c99dae746f17d7d8e4143e4443ebf9ad1781e27d3061beb919c466f3157e50e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b4c3f1b6f8141a900f33c21ecf4e5429cd2e1fc470ed3cbceb487e5e3ce9bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "72d80518bdae9da8407b87dc47c7feb070b48c5a840e27cd828d69379c717860"
    sha256 cellar: :any_skip_relocation, big_sur:        "52bb7fbf00bfa3f0b32c9808d3ebbe640b365d722cff6765c12b7d942feb93af"
    sha256 cellar: :any_skip_relocation, catalina:       "f16cea1bd35d231e567117c12d58798de1eeac4d5e3c36934d92ca00bbf9e1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcbee7b32cbec24b48e2964500b7162ff5808db7311b0ad3f3acbf9c9160c8bd"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "python@3.10" => :build
    depends_on "libxcb"
  end

  def install
    # Upstream specifies very old versions of onig_sys/cc that
    # cause issues when using Homebrew's clang shim on Apple Silicon.
    # Forcefully upgrade `onig_sys` and `cc` to slightly newer versions
    # that enable a successful build.
    # https://github.com/jmacdonald/amp/issues/222
    inreplace "Cargo.lock" do |f|
      f.gsub! "68.0.1", "68.2.1"
      f.gsub! "5c6be7c4f985508684e54f18dd37f71e66f3e1ad9318336a520d7e42f0d3ea8e",
              "195ebddbb56740be48042ca117b8fb6e0d99fe392191a9362d82f5f69e510379"
      f.gsub! "1.0.45", "1.0.67"
      f.gsub! "4fc9a35e1f4290eb9e5fc54ba6cf40671ed2a2514c3eeb2b2a908dda2ea5a1be",
              "e3c69b077ad434294d3ce9f1f6143a2a4b89a8a2d54ef813d85003a4fd1137fd"
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    PTY.spawn(bin/"amp", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # switch to insert mode and add data
      w.write "i"
      sleep 1
      w.write "test data"
      sleep 1
      # escape to normal mode, save the file, and quit
      w.write "\e"
      sleep 1
      w.write "s"
      sleep 1
      w.write "Q"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "test data\n", (testpath/"test.txt").read
  end
end
