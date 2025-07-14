class GpgTui < Formula
  desc "Manage your GnuPG keys with ease!"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "ecc232b42ff07888eb12a43daf5a956791a21efc85f6e71fbed9b9769ec50b50"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8b285a56c068c4613ddf7febc02f54f3f93e5b981e767d9e780e46c222da68f"
    sha256 cellar: :any,                 arm64_sonoma:  "3ad65ce292ab237367a5e9c1243fc8e1c661ceca8866dcc1097e7fb343391483"
    sha256 cellar: :any,                 arm64_ventura: "27e2c82100509242bbae369f1e07446a39d4601b16bdfa81d64bf84f65fc4ccb"
    sha256 cellar: :any,                 sonoma:        "d7cd4bf0315b5286844fa5a79de6c1e6b03ff8d678c107dab39bc13d7917ddd0"
    sha256 cellar: :any,                 ventura:       "ce5156604deb713f9ef54ec0a1bd517a32b7adcfe38b9128ce9ba20a9ef746ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859083fd3369401fd250a7219b0dcd2aeae9d73737e25f540d9b3a79e93bc31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3674a2853d140537e9f8859d4efc566f55a4f1c0d3a67caf1fee55c807fa2ea"
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
