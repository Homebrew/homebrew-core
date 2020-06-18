class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      :tag      => "v2.0.5",
      :revision => "fb258dd57a5880f4e34822578a88135ae6f67cd0"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "457988d799943a31341895d183f5addf88bde337fed82957bf0f68eaf935923a" => :catalina
    sha256 "23f3bab4f14b2e98780bca7704930bcf9f5edee89de4f8d8fe9894facc5ae21e" => :mojave
    sha256 "29911e12399264c7ebb7241b52718a69f6788a813e7ec1a940c3aca8a1896726" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
