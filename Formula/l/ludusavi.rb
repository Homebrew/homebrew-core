class Ludusavi < Formula
  desc "Backup tool for PC game saves"
  homepage "https://github.com/mtkennerly/ludusavi"
  url "https://github.com/mtkennerly/ludusavi/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "c5aa44b95326028df48c14efd9d561991c0eb19c66bb72b8f21394a04439d1fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf745c809c70dcd6f71e8a10400c1821fb70f9fc4fe92ec497601a9325e4c191"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d306fbb21b311853bfc6be773ed3d04873b584e64a9248119bf55b6d69b5ca3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24b263950a4ca50aa9bca2f7854db20fada0f13344c81da4986f3ab8a86f2958"
    sha256 cellar: :any_skip_relocation, sonoma:        "c09334e2feca9145b98f139b6f135c90039a0aea2ae2e1336eebbe3ee1e71ca8"
    sha256 cellar: :any_skip_relocation, ventura:       "5064a4c570b64b2d09db1bdd0479ae9032b0df775dbec42116a6d79a8d4b43d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be7f68c98391736dd9865538d22f6a2bf4c3f3b1a775d5a1f65a2f549f46e61"
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
