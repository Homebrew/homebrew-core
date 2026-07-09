class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  license "MIT"
  head "https://github.com/ReFirmLabs/binwalk.git", branch: "master"

  stable do
    url "https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v3.1.0.tar.gz"
    sha256 "06f595719417b70a592580258ed980237892eadc198e02363201abe6ca59e49a"

    # Backport switch to 7zip
    patch do
      url "https://github.com/ReFirmLabs/binwalk/commit/b83242ffbd54997d11c7f7e304c17bf9582e38fe.patch?full_index=1"
      sha256 "3a9e9f43ee552d6c3ab3d8069524a786b95f1256969f30400c679b1cc19e026c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80c4dfbfe2c50dcd3f11b76d393828aca82f80c95276d614c52678c444b74457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e02cd149f0d1ebfb784f2643048c13ca755370ee86d0b872dcfd8acce80f3b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e523d08d8abf564f4c2cdd4f3af8256c7673f97dee2e1bedcfe12d47e6b3879"
    sha256 cellar: :any_skip_relocation, sonoma:        "50dc5e36ebd07c8b390e84fed31cc21219142550274fddb9a476246443ee86de"
    sha256 cellar: :any,                 arm64_linux:   "2b768196bb7a654e79e96961c0b1c54498e9034e6c21e9082a18008da25a6bbd"
    sha256 cellar: :any,                 x86_64_linux:  "f88d21e81013dfbd4446479d227d52b024402ab593c47f625326a9581b7d00fe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "sevenzip" # for 7zz

  uses_from_macos "bzip2"
  uses_from_macos "xz"

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
