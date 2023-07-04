class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.6.2.tar.gz"
  sha256 "9279efcecdb743b8987fbedf281f569d84eaf42a0eee556c3447f3dc9c9dfe3b"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/jmacdonald/amp.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d19e2cc1f1bdc9cf5372a8af26514dcd2bce4945d15bb983c2f42925fe2172e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae421ef5b240a2fa442897dc594c237a77b7f72de3d8566cb3e99776552b62bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82e8807dab0c43b84aaf807c0e458214e70705333f55a67b31ead8eb78d4dd5b"
    sha256 cellar: :any_skip_relocation, ventura:        "667e2486099549c5d67c2d22e03619b957c196cf3b9d07c3fcec00590698f7ee"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b628ccf34ed9277b22f908d57ea12ffca9f4f71af25be554548e20e7e55783"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0813560d9c8739aee6559aae7c0166ce425db267dec97139007ba0a2e62caff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1dc1298c845079321d6456053f16d4716c726b55da1c891e11107115acdd0d2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
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
