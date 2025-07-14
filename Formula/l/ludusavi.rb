class Ludusavi < Formula
  desc "Backup tool for PC game saves"
  homepage "https://github.com/mtkennerly/ludusavi"
  url "https://github.com/mtkennerly/ludusavi/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "6f1ea88f2483a1179d6797239fc4a57339e8c870add807ceacaa50a239031f0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c3a1659aea16888d65dd44b04a5736feaa9a9694b2da1fdf374f184c8a505b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6d6e9fc1a8e8ad4623a7c1de10c853154e9cf27c1e29c9c15db9976f8dc821"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08182afdde260dca52f78cc5963030cb3e592c0b8aa98c10a2f2a5fec90d4bec"
    sha256 cellar: :any_skip_relocation, sonoma:        "41c247766a740b47f75a8c179d46bde5b7cbfd24994207dfe1210e9eb4efda0b"
    sha256 cellar: :any_skip_relocation, ventura:       "a2f42cfcafa79a56216f8054d18c27264ddfd898876e050c3defa888d83579b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ce8f9c00d42db1ad10a5dbfbf3e690b908e42dae62bc98972d80ae1c1739a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "173211d56a87aad433661256fe23e6fef6e7c8460320714f2f4702415062d6b9"
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
