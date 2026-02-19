class Patchpal < Formula
  desc "AI Assisted Patch Backporting Tool Frontend"
  homepage "https://gitlab.com/patchpal-ai/patchpal-gui"
  url "https://gitlab.com/patchpal-ai/patchpal-gui/-/archive/v0.7.0/patchpal-gui-v0.7.0.tar.bz2"
  sha256 "71244017fee6dfa9505603f2ccbb2c534d9211bcb73a3d8dd30745d3958e5a22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "055cdb0726c7dc7620604fafd76c77b4bbf9fae9e009a525b7243e5e8123981f"
    sha256 cellar: :any,                 arm64_sequoia: "e9e594b44c02bf79b28ee96a044a485f18ea02a1640b6e32804bfeb77565ac5e"
    sha256 cellar: :any,                 arm64_sonoma:  "81d7fc5d1f1599eb351b8ec15763d95873398d408af3630dba3ee8b72652de85"
    sha256 cellar: :any,                 sonoma:        "0882305ca6ff530fdb837aa847be76582c7fc4e4e65134cada5002d9c7c1445f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1646ccdaeaab2024043823220db3cff8264ad0df7df1af2913809b27fe9ffd91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41690899f331b5fcc072b6c066fbb79e10e7d30aaca80fc2d19d9c802d95ae33"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "llvm"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    if OS.linux?
      xvfb_pid = spawn Formula["xorg-server"].bin/"Xvfb", ":1"
      ENV["DISPLAY"] = ":1"
      sleep 10
    end

    system "git", "init", "--initial-branch=main"
    (testpath/"test.txt").write "Hello world"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "initial commit"

    system "git", "checkout", "-b", "test"
    rm testpath/"test.txt"
    (testpath/"test.txt").write "Foo bar"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "to-cherrypick"
    commit_hash = shell_output("git rev-parse HEAD").strip

    system "git", "switch", "main"
    system bin/"patchpal", "--commit-clean", "--no-ai", commit_hash
    assert_match commit_hash, shell_output("git log -1 --pretty=%B")
    assert_match "Foo bar", (testpath/"test.txt").read
  ensure
    Process.kill("TERM", xvfb_pid) if xvfb_pid
    Process.wait(xvfb_pid) if xvfb_pid
  end
end
