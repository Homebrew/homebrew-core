class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.9",
      revision: "6bc498e625e66e3d0c947639dbffb09d986318d0"
  license "MIT"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44592bcca54de4d876b978c4e68631a9c31bdf39c65d961e9700ef6ed05af292"
    sha256 cellar: :any_skip_relocation, big_sur:       "876f97a93335c70abf96d30d1bca0a4e6dc68f532205a7843451f25184764e97"
    sha256 cellar: :any_skip_relocation, catalina:      "5d95bee552c50d29d65f4b8bc075a7b2d7d0dddfd756d608e02897ab93fbf2ef"
    sha256 cellar: :any_skip_relocation, mojave:        "64717e9a4926f13813f47ac3461c4c610367f316b672bd570fee6d9721beffc3"
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
