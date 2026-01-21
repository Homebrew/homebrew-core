class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "cbf3125faad016e5b226068e74493ecfebdc10df6398d91987479c26e93b2b39"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "795f7fc8e9932a3021d522137751e73317a592af2cd82b6c092cd0291bc365b3"
    sha256 cellar: :any,                 arm64_sequoia: "f5fc0d002a697e1f370e0b0fc926a5b27cda1bc5415e335bc8fe9f56fe72a8db"
    sha256 cellar: :any,                 arm64_sonoma:  "a8a8c249fa6f3e681f9192156d4f1247eef60013a4b9df6c63d5d88d683353d5"
    sha256 cellar: :any,                 sonoma:        "c45f801213dc6db58031bcfd457d1f44cf5ffb8aa11e3fbd927d7dc87b8d66d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "486e4d25f453c3978ecb50f4096c684f964ff6ca36e1b294d82bdb317b99639f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2dcc2fc58d0370020d18e9471cca2b4de6ecac125ae7af0111602bcdddf1f37"
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
