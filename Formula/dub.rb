class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.31.1.tar.gz"
  sha256 "dce1b3f7d21f6b111830d849e6f417853bab66d9036df212aec237c1f724bc4f"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4d65020cdde5fac667c6aefdb25968c4179eea7c776b2aaa9671cffd4edb9e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b94fba9b7886a0aca23cc3d11fd8add55a4c861c648b990998f2436a037585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59bce14e8905a2f2dcb0ae35ed425755026defbfb7aabab69a8e93910188a809"
    sha256 cellar: :any_skip_relocation, ventura:        "75a38f7d9e1d45009b29180ad96425e52bcd72731a6be8ca56476d4e3c77e0fc"
    sha256 cellar: :any_skip_relocation, monterey:       "ddfcf25c04859be3b74eeca843b1072b00a779deb408a12013dc26090b48c84b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0031bae24192fbc918c4462dfa0ce5a539685f0cb4ed2bc1f85c1bdfb3d762c9"
    sha256 cellar: :any_skip_relocation, catalina:       "22c9691136ed173c667a0b2c4c2f598488ae260c3b6e47188696e9414f18b4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c743c8316481b0030e2dc749d732aef8d5b7d9e39029419f7ae7ff0e2b64903"
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
