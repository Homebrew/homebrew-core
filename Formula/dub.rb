class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.25.0.tar.gz"
  sha256 "b9ea1a6a3d69ba4a4b522ad1e1e7f9b17c08e0d872b9a6d125ab6bdfc2b42957"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "eea63ed91407b03fcb3ce5a812efea3b759356719f41aef40289502d5a0ffb8e"
    sha256 cellar: :any_skip_relocation, catalina: "1204eeec46c4a66a55f1834f78dd6ac72fb5a713ee5bf5f2c4ce335e7f84fe8e"
    sha256 cellar: :any_skip_relocation, mojave:   "8b11bd3b2eda8084026f030de3a4e2f90f6da010239caa6141cb09650f6015ed"
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.d"
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
