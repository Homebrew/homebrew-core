class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      :tag      => "v2.0.2",
      :revision => "c51f84955e5fe924c34b4f7e06d17cd8731022cf"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad978b160088bdcb1101b67d8ef286b663897bb5033a5b40f0459e3ae5186a45" => :catalina
    sha256 "9a0973d51f5a4b7ffcd7049019372c098c28cbad03a293713160a2813bde860a" => :mojave
    sha256 "bc0a4d9f71efd40c43e99117ef950f0c11763e44ef8ce7cb5be2f244a84e44f1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
