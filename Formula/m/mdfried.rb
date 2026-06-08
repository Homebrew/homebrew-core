class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e8055e887e354aee290c4d3f9160ec40e169d5fbf891910c89d259df72cffe2f"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e58b6cb0ba75e2be99cf7e6e7581600545c34e4dbfd19002827fb54724dbf492"
    sha256 cellar: :any, arm64_sequoia: "68e1b142c7388ed065a194a7af7a00a8c9a2340d95cde039c25f117150936575"
    sha256 cellar: :any, arm64_sonoma:  "4d3e7504292a1b8947de4f120ff6582d6622a2bd7d43dfb647e77f46826b2dcd"
    sha256 cellar: :any, sonoma:        "bbae38a5662281ef4790cbbb72bb112a34762209ad09400151d2bdf9e36d1785"
    sha256 cellar: :any, arm64_linux:   "f91d4da250d994ef8aafa94af84a9729ce3d4c618422dd96e3db26c57c2a2eda"
    sha256 cellar: :any, x86_64_linux:  "ee015685a84df60e868da5080c09c6ac3d65f3929c79ebea5ea95d2132e6a922"
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

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
