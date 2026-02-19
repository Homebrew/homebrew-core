class Ludusavi < Formula
  desc "Backup tool for PC game saves"
  homepage "https://github.com/mtkennerly/ludusavi"
  url "https://github.com/mtkennerly/ludusavi/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "3e819da8d6c6b2e673fb0dab2c64524d448e45b66b009ced7cb2a324f201dc6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0b377fc4de6c6d5f16869df5d9140f17e3be45dbd874f7fce533ff78110b397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be439e8462a16a1c5e0adbead1aa0b370a80eefdf39f3e2d64902333d3beb1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99ea928a9b4a09c2e241871c9e0c458bf1ba88b9831c67b6b5245177120b400e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f68fc35bb6a9804164fa8fa415ab1346b00cbc56cc95034f8bede219d19f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "281c910e1a042d4e0650c6c197186eab3c15655502fd3b1e3a8fe262c2f209d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa58d518c71e8ed09384962aadad26697ce4f866ceea47971941cf446ab9223d"
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
