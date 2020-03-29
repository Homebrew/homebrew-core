class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.1.tar.gz"
  sha256 "f497b335c3c63296ef686c0ce57da3ef71b731636477b6debf5a8f91402c5785"
  head "https://github.com/bootandy/dust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d26a2fa524049d8b2a32b3076f7de243c7929c943b5c0190d8cc5c9a2ba41d3" => :catalina
    sha256 "3e92fcb18d37bd8dde1d8e52a44c8f96a5086a7afb5ced6895262af0b3e8395b" => :mojave
    sha256 "ffa147a323f5ff57cbea0eb8817acdfff88c1f349f5f1f35d0bf3dc64e6c8faf" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
