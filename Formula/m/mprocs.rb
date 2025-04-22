class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "13059e3f474b17b0d806b2b6a79c17dd9b817793a0a6442ffd43ddaacb1db60c"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a57e422a9ce6bc06b5cde9fc4a4f6e461587a3bcacd641a70dec691ea8b3d27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1819269384051c7fecaa338edae853b7f7cf4eb8782a230a18e23d6d152e054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c41ca551b20bfe19729407fab771d7271e0ae382ece946d248fbdf364f931411"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c3e50b429cef4068997ce7c9b18711ca4e6df1be6bf0e59ee97af3ccb202661"
    sha256 cellar: :any_skip_relocation, ventura:       "f82c17acb72bc3ffc783ee1488084ddee1ce98f7920e8333609f3be868d1c8b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e4cd9a9f153a7a8cc3bbd92e7d6c9d8cccd391c2b6b1364c19058915108cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa1c70b7654a7950eb5bc057cdb700ace216b46ad0f903d771ab2535f1cd2c4"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
