class Patchpal < Formula
  desc "AI Assisted Patch Backporting Tool Frontend"
  homepage "https://gitlab.com/patchpal-ai/patchpal-gui"
  url "https://gitlab.com/patchpal-ai/patchpal-gui/-/archive/v0.8.1/patchpal-gui-v0.8.1.tar.bz2"
  sha256 "3bee167d923999f6a616ab2025d16e73641638d2237565f8f39eb28d35930c8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c3a7bc18acdeb0e644b3580ed109fe9a0c57a43afa7e1a7026c0d8bed737372d"
    sha256 cellar: :any, arm64_sequoia: "e04418ee7052ba37dfde718c5cc1b0f0b7fcba29fd2d67a6058f2ffd7f03e204"
    sha256 cellar: :any, arm64_sonoma:  "9734accbb9c6897a3eb41e1c2c6e1258b8bf5361e88288d8f8c0a451eb4a5dcb"
    sha256 cellar: :any, sonoma:        "4998c08724fa8ae7ae2f798d22006bf2bd5092d00f826fad448f142eaf9a89aa"
    sha256 cellar: :any, arm64_linux:   "ab9aa474a70cb6b4561b60f3c413f620228666600ef23ef34df5d5b8ae20941a"
    sha256 cellar: :any, x86_64_linux:  "50f52d4441b81965edf8ca1b1dde7c69aab1324a305c9263e0a7e95d6356603d"
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
