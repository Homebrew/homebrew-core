class Patchpal < Formula
  desc "AI Assisted Patch Backporting Tool Frontend"
  homepage "https://gitlab.com/patchpal-ai/patchpal-gui"
  url "https://gitlab.com/patchpal-ai/patchpal-gui/-/archive/v0.7.1/patchpal-gui-v0.7.1.tar.bz2"
  sha256 "cfc7ac868a7ad917aacd362b04b0bda10d5dcf83cf92f1a5171cc30f8e877609"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9a475810e8411ec3754d137282cb6a95f0b38b4a941f9f964f8bf74c973f692"
    sha256 cellar: :any,                 arm64_sequoia: "3373399d757e5e9085d5c835fc28c92c0bdc15a07b627704a6efd6730a74d9dc"
    sha256 cellar: :any,                 arm64_sonoma:  "51077fe5336f64606f9dfd1152dcb2c2935fe145bb811efc981300876953e80d"
    sha256 cellar: :any,                 sonoma:        "064c1542ebff12a3b0e787da2e76f4ce8a48cf1c0c6987939813cf54ba629899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5313d5e3b77ee9a60037f850d081dba81d9904b5ea655e3f75f8d19f9c4ba13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1111812901527caac9bae653b5520fab630c98d971ed1e4983b6feab240b03c4"
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
