class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.6.2.tar.gz"
  sha256 "9279efcecdb743b8987fbedf281f569d84eaf42a0eee556c3447f3dc9c9dfe3b"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/jmacdonald/amp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7318b0f8536a81b08e98f80f1bc409758122aaad61fd38ff09f4540fb0b5a3b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a76be7ab5cd8388905d353c50f2a8b760b6b9082f3a715ba481f2d4ae8d622e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc1fe0166588fb8770bef1b17d88d2c818fe24167604833f799fc7e75c118bee"
    sha256 cellar: :any_skip_relocation, ventura:        "a2efcbff4e557ec7e2060838a7925ae8908955fc1b5306245ef5caa11dd83550"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c26461404cfb029ccd3b90180a70821d1a028c24a550143916c293fa105e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "f95b210ee770d8909bb5190c504658b818b307f909b82f8df3ec87f2a5e55e57"
    sha256 cellar: :any_skip_relocation, catalina:       "81535aa6c50a8b0dab7386bc7efbd6fe6307724b95fc18bfff51e1ebf5c30730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b03b886d4061d7eafac7dd9f72a15c6f2ce356883eb4fb76afd278fd24c2f7"
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
