class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "4e9ee948a1d4b952fb7461a59f457fd256ced8740403629ac8704d070a68e927"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6eb9611c3fc0681455ad3b1d90b2cbe8380023e17c73cdd5ace0b2ea7819af58"
    sha256 cellar: :any,                 arm64_sequoia: "36bc2cfe860f4e22165b88275ae45fc2acec56fea98855ba2e5f887bc8e0e8ef"
    sha256 cellar: :any,                 arm64_sonoma:  "a874f9e86ffb9fc22b87acfed3005ab4d271802804ae06893d6a07ea9dd8153a"
    sha256 cellar: :any,                 sonoma:        "7cb567695c8562fe6d932bcb20d281ad4bdbbc7bdd8d5492fad339d83f531518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0376c093c1ae32f9d55954dbf5d04cd4c56a116ce78cdce850d74198ee2fd212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522d827583df064c2c5a083aa6dd45e589e1c9a31f47d568863170e1b54cbff1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    cmd = "#{bin}/mdfried #{testpath}/test.md 2>&1"
    output = if OS.mac?
      shell_output(cmd)
    else
      require "pty"
      r, _w, pid = PTY.spawn({ "FONTCONFIG_FILE" => "#{etc}/fonts/fonts.conf" }, cmd)
      Process.wait(pid)
      r.read_nonblock(1024)
    end
    assert_match "cursor position could not be read", output
  end
end
