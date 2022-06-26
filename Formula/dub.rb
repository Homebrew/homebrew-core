class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.29.0.tar.gz"
  sha256 "4adf1c9101f5489548645cb4edad4b291d031149f7d970df44e3fc614b46dd2f"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e11f26f2d9ef5fc6797c06cdda67d5dd2dca2b0002e39fce442678db91eda4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "844ddc8a9679b68b58925e9065f68ab69dcc50def6612446cc9d6a98dd265fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "270619e8c3d7f3d6e5dabee528ded3041d3c21461fbaf93904e367ba19f3d2b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a61fb725ade4bd3f2c3c4905dee99d12a69eff6cf87b40a661c387b51b93ade2"
    sha256 cellar: :any_skip_relocation, catalina:       "522c79a6e56742d21af1e1d356b33c56435adb1fae248c93c85430f4738c8dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca6346d69f03f8d297d4858ca03341d2c1064fe461f659e8630110870ad09d2"
  end

  depends_on "ldc" => :build
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
