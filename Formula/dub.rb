class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.24.0.tar.gz"
  sha256 "4d14ba97748d89a2af9a3d62c1721c2f92bd393b010a9a4a39037449941e1312"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ffbc50022b9ee128b0ba6ba5d2833612d16b060ca79f98dfea410bce0252a635" => :big_sur
    sha256 "3a1c773ad05662b24ddecacd2b008029e731178eab826a4945db34638ecad06a" => :catalina
    sha256 "cb6ae1c85097a78aa6e0bccc14a5c485159058d5697defe48890648d5e68476e" => :mojave
    sha256 "25b8feb7408b60d13bcd61bd71acc3cf77ba31405a2a626cdd731140d2548c0a" => :high_sierra
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
