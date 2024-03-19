class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/refs/tags/0.7.0.tar.gz"
  sha256 "d77946c042df6c27941f6994877e0e62c71807f245b16b41cf00dbf8b3553731"
  license "GPL-3.0-or-later"
  head "https://github.com/jmacdonald/amp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0602d51ca846b298ce8a461dcb6f77fded1230508a374351dec16c2ca81adb0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f64b6e1aad3d6019eb20dd368cc31185bacf34907b46cf46941bc10b2e42887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71335f514f8823bd44e604c8b7a68ddf9f28d5a3fb598a8246838d6dadc0ce66"
    sha256 cellar: :any_skip_relocation, sonoma:         "87ef68adf7b5d627d22563f4d074845c2917dfce0011f0b58929f1632a15caae"
    sha256 cellar: :any_skip_relocation, ventura:        "fda6253e67648534e7696ab6832d4c773f224d4b41a534ff9166c60fc9b2a59d"
    sha256 cellar: :any_skip_relocation, monterey:       "5695be774969b81034c659f2ed38f9b2b3cd35549a189e275af15333d9ab97fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7591ce6c472ae8fc567bab641bdabc59aa721b0cb0322ea468bfc601a8a8c66"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxcb"
  end

  def install
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
