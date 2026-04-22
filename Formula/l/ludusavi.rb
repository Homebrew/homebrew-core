class Ludusavi < Formula
  desc "Backup tool for PC game saves"
  homepage "https://github.com/mtkennerly/ludusavi"
  url "https://github.com/mtkennerly/ludusavi/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "e7dcfa4fb17fcd2be9ef34d55fe0ca0d3f79fdf570107aeaa5b4e76910e2f8a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa571ed70c1b44b91c431bfb5da7f2e507096a4da3b94172cfb675b407edbb2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68065a401dacb9e69956c3bb02def5d0222934226f3b61fdd3e263e795aa7f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c29e00ddceb7ff41554301a35cac472e926d17cd50c6b97a919a799c2f49e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "492a312b84ed50da4ffa5eb20a1d7f898f6cd1d29d358601b60be29db7da8058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ed88e163856b0af1b5a92724308d3d965f613945b625733ea6b741b8922e272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d0fb16e4ef81c9beb1449930043e2b69ff8c69893ce94c5cb5a12a8ad29c64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ludusavi -V")
    assert_empty shell_output("#{bin}/ludusavi backups").strip
  end
end
