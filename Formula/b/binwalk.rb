class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "06f595719417b70a592580258ed980237892eadc198e02363201abe6ca59e49a"
  license "MIT"
  head "https://github.com/ReFirmLabs/binwalk.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11b3d0c518f81eaba097392205c002a136e25b73a81ec35551b9ca1e3858c700"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00db81d196265d847f7241a8771bade058a6077c0db8701fa0345496b7ba1f42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2640baf0e4b7943cef7df7ff1280ebdf1bc47ba711cc53d984eef63d24c5022"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0ff3203c523ad5b7551b711b4ac5cacd6fe1d1d934c9e8c8a54a6745f5b7826"
    sha256 cellar: :any_skip_relocation, sonoma:        "3666d1ed2f81484d360d03bba8eb74a5175dd5a0461175c20bf1aa559e6add6f"
    sha256 cellar: :any_skip_relocation, ventura:       "048ab0f16801129c741006603da6545c267ec98ea3c349537f22ce8d03ceb038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c28f00bf24601ddcb037e1822dbea082dceda5f26ac9a152e11d78532a488b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bad450fef7ba5832e71804dc11fcb87d817fabbbf735c2b1dc9fa6c508a1090"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "p7zip"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  pypi_packages exclude_packages: ["numpy", "pillow"],
                extra_packages:   %w[capstone gnupg matplotlib pycryptodome]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "binwalk.test"
    system bin/"binwalk", "binwalk.test"
  end
end
