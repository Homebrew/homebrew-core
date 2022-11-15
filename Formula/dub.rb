class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.30.0.tar.gz"
  sha256 "840cd65bf5f0dd06ca688f63b94d71fccd92b526bbf1d3892fe5535b1e85c10e"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1279c482fa5f76b4f12f9fdd2155d06c8210321a6b7f32ac3821e7d89611bdba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "084b64b8299fc45a2466a7ce0cbc2dde2a2302097a5f7af058475f789cfca267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "300d04b9cdaf03c410bfb29540af2e1df1f88705b120632e47b5796fb2d5f2d6"
    sha256 cellar: :any_skip_relocation, monterey:       "3d2dd534cf44a3793809443aa003d17dc83f8370d3c0f9ffe8987da6ba70b82d"
    sha256 cellar: :any_skip_relocation, big_sur:        "24fc05d36186fe08d103b62ba4145112c1c995360671cd406d76195844549656"
    sha256 cellar: :any_skip_relocation, catalina:       "12420e7460ba50e22aeee6d2cacdf7bc0ac9057e86a99909b40979da142f84cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67253c6642eab447d0cc34aef79be92b9bf5d6482de19b6ca0bcfb9e2a4a7b9c"
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
