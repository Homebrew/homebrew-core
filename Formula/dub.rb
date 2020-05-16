class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.21.0.tar.gz"
  sha256 "320d96453b4a9a36a2d8716307cebe44f53638e06f425a7cc0d7d4dc9379bbe7"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1898672a92d98538a1c1ca1f613abaf8031117b2c90e3f180c92af1f30e88234" => :catalina
    sha256 "13547ccbfee2105026686a2ccce669d2c2e029a889bbedea3d3cfb4c2584a0f3" => :mojave
    sha256 "9721f4c53fd852a4b283050091702c820dbc6ce5971161dbfb1be27552598228" => :high_sierra
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
