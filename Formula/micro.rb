class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.10",
      revision: "b97638566ea8431712f0faafe23661da2db0e8ec"
  license "MIT"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8a19557c64667e27d9dea4c4321465297ec8669d05566518b7f2bc4b39cd88b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cb2c86f690a52f3242021d6a567b0f15943f8c68af263298aae17c67bdcfcc4"
    sha256 cellar: :any_skip_relocation, monterey:       "455091c0d41b4f4bc2bb8f4c7a00f61e1231df00e7b8be557127f652df358603"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bcf6e60611b745183aeda8294088f9b42bbcc367ba9765c570b6c4224e26047"
    sha256 cellar: :any_skip_relocation, catalina:       "2915aafc3513241afd778caeadc146ad0df2a7124e03012c1bf2ba867194deb2"
    sha256 cellar: :any_skip_relocation, mojave:         "35b0c0717cfb5c7c78cfa2f51bf162594f7f6f84ac88243c51e40c0ada9fb496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a284bc50e33f7792f802e460c2c400ffcbfb392927e6ece1dfba876c5c5d33f"
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
