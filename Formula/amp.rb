class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.6.2.tar.gz"
  sha256 "9279efcecdb743b8987fbedf281f569d84eaf42a0eee556c3447f3dc9c9dfe3b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/jmacdonald/amp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a16ac20a15f1ff7716824be467f4980b0e3ab1f99326539d9a8b086eece946bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f001a886b5ea456bc925ae37ef45c6f5ae70ef8506ae576fe3f831e78f2ecbcb"
    sha256 cellar: :any_skip_relocation, monterey:       "08fbf3e6231fec7cafca9fcaa85e498276b12a5866bb4f918384b551a704599e"
    sha256 cellar: :any_skip_relocation, big_sur:        "db4b6bdf3468476c2f2b6696f755c05b2471f6d09bc47bf783fbd6c65b1b1aac"
    sha256 cellar: :any_skip_relocation, catalina:       "6b886491460ff6245f9f6ecd22d0a856f51afbd06ec7adf13e2c8be974693656"
    sha256 cellar: :any_skip_relocation, mojave:         "8d11d70c1a7ae6bb4cf3c4460ad93a303a7ec4bdc63166ce0796f4025c05d517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c6bbda9b197a6d0e83923d15d82cee7e0f72cd5d7416dc32dd3bd993c8a8fc4"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "python@3.9" => :build
    depends_on "libxcb"
  end

  def install
    # Upstream specifies very old versions of onig_sys/cc that
    # cause issues when using Homebrew's clang shim on Apple Silicon.
    # Forcefully upgrade `onig_sys` and `cc` to slightly newer versions
    # that enable a succesful build.
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
