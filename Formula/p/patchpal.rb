class Patchpal < Formula
  desc "AI Assisted Patch Backporting Tool Frontend"
  homepage "https://gitlab.com/patchpal-ai/patchpal-gui"
  url "https://gitlab.com/patchpal-ai/patchpal-gui/-/archive/v0.6.0/patchpal-gui-v0.6.0.tar.bz2"
  sha256 "452682aac75201a785155308326f15ebcb344cfb0a16e3f0c0c88a9758d76e44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed3fdaeadc6ca32bc785e6a50bf0bf12891eeeb8ee83d1dc1940b7096be25f3a"
    sha256 cellar: :any,                 arm64_sequoia: "05eb13cf2c732413c7f0370941f47424f98a31c1496d826c50dadd21aad88df7"
    sha256 cellar: :any,                 arm64_sonoma:  "3290ede113c6e6c018b621e488af651881d57734bb9e2f1d36773f5efcec3bc1"
    sha256 cellar: :any,                 sonoma:        "e176488c998688d8fed8ae3bef3cac933e914b8b98310d12cead4defd6fcf730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a135e7c4073c0bb8ea834e7d3e6e80d0061824eaa90a897b77cd522d2fe8098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00912762acaf66ee454284a2f9f5ef83cf424e4ed26b636f354743d5d63cae1b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "llvm"
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
