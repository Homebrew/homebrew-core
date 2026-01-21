class Patchpal < Formula
  desc "AI Assisted Patch Backporting Tool Frontend"
  homepage "https://gitlab.com/patchpal-ai/patchpal-gui"
  url "https://gitlab.com/patchpal-ai/patchpal-gui/-/archive/v0.6.0/patchpal-gui-v0.6.0.tar.bz2"
  sha256 "452682aac75201a785155308326f15ebcb344cfb0a16e3f0c0c88a9758d76e44"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9ec3667a5465d04310a8ed0494964d4d46587bb614bea2f2ace5f6dde26a36b5"
    sha256 cellar: :any,                 arm64_sequoia: "1e495f29b0bfae5a27e1e4dbe6b107f7ea5828495dc1cdcfa5fcc5c37a9619c6"
    sha256 cellar: :any,                 arm64_sonoma:  "ba360627b1f49bfcbb8e05a6ed187970ba2761f36d4ea69c4352618cbf21d677"
    sha256 cellar: :any,                 sonoma:        "f743492a8757db7aa2a2aaa18f37327362d892c4e8a80abe7db1b95c92a7e360"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8c0ce0d1c5975fb1dbe146461147c187aa1ef215c4abe6d753c3ab7c5d66a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c79d015a7f15a5862c66729731c4886bc6e2622f10ff05911e67b9c6933f990"
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
