class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.15.6.tar.gz"
  sha256 "aaf0f996c082a5b66b56daf9fdaa99e1431eaf54b0d31e9584d6e0dd0a27a4d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7da5547aa1e225bbe60cf4cf74d155f5ddc621965cbc78335427b9e01ca48b49" => :catalina
    sha256 "d3d5f3ba5437490ada57c5b18a7205b554df5fbfa6a9f9d40c71eb8412a5dd78" => :mojave
    sha256 "d620530bc9fa5040165fc8d50ba9b2240ba2275d9f394f8fcace27f22f151b0a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
