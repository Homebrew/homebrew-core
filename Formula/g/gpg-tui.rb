class GpgTui < Formula
  desc "Manage your GnuPG keys with ease!"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "2cbd0186b76b7bb5b4a21c76b2f4b344c03194731729aac645465f33d665ef91"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94e1ca211a1dbd8fe30446a69bfeb8a47d927c5085bf49a597a3ac4cf8c02147"
    sha256 cellar: :any,                 arm64_sequoia: "004f11be603db86cb34c5adfbcc867fee9614e62815954f334d60d4fdebdfb99"
    sha256 cellar: :any,                 arm64_sonoma:  "b1535956bc250a00702761aff88d4a4c36ca3fb87dfd53dfa49c1e1acb0263a2"
    sha256 cellar: :any,                 sonoma:        "e282e1cf9ad5e3982fe3bb378e08bbc587fa154f118580cd34d55135152fe5ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7d236c7c210cebc61aae6c46fafcad1fe4db43b1bee5ec4f50534d54fe7501a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d10147ccb1179dc6968a51fd20c95c108ade11a5fb36259bd5e315faa06639"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"gpg-tui-completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm(bin/"gpg-tui-completions")
    rm(Dir[prefix/".crates*"])
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    begin
      r, w, pid = PTY.spawn bin/"gpg-tui"
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
