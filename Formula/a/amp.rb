class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/refs/tags/0.7.1.tar.gz"
  sha256 "59a65c2c4592eed188433fe7c4bf2ba84206f217bdafc5a2c7f97623f5607c12"
  license "GPL-3.0-or-later"
  head "https://github.com/jmacdonald/amp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68d39d4763586359bea02f2ac21612dd8c0a0fb6030bd02981c5d5f57ce8a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "434286f4bc1df2e76c8396ab3e72e63d78482aabe5e7fd6bcfb1b5c2ea750873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb8df298bd237bb41f7aa836be081fcfd3e772179c207773628b77737854b3a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e80a76fa14710e2778d4ffade1dacaec64957c00196b41f578839ea570d1df75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "401144f0dfe99ea1f3e498417b000aedfcb165f5cd75346cee3e287263f0c709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12cefdab22a6ef3ada34249fcda4837d5fccfe7c20f2816945f2298b1e68c2e4"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
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
