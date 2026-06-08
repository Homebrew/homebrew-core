class Patchpal < Formula
  desc "AI Assisted Patch Backporting Tool Frontend"
  homepage "https://gitlab.com/patchpal-ai/patchpal-gui"
  url "https://gitlab.com/patchpal-ai/patchpal-gui/-/archive/v0.8.0/patchpal-gui-v0.8.0.tar.bz2"
  sha256 "3be3a1ee5d6ed988cb737aa904d70cb10653925bcc21a318b19b52257c30ed36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "044e0555bff1917befa7aedfa1320678da0017a09fe45489edfec91c1bcdfbbb"
    sha256 cellar: :any, arm64_sequoia: "d125883e8880ef7eec6c401b28cf0929fc5cacc34313f987d58724b1bd2b4e41"
    sha256 cellar: :any, arm64_sonoma:  "21486130286e41bcc2f71ce921019ec7d3e52feae5e434f36e6da059479f444d"
    sha256 cellar: :any, sonoma:        "0bc5b7252ff66fba9c7c0f7d5bcfa00557f1c46c124d6676c905e927c80e9982"
    sha256 cellar: :any, arm64_linux:   "6883193cdb62130efc2824fefda24909d50c8afde7eb3c72b861f2f3427d2c7c"
    sha256 cellar: :any, x86_64_linux:  "e24707d6c0e4d120eecc81b33ed243d9916ff0c766e42ce79a94331315f8dbeb"
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
