class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.24.1.tar.gz"
  sha256 "1e601b8dbde9ea041715a2be7ac243f573912fe38ce636fa1cacf09605a1cf95"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d79d4b4e6b2ed53f6908798ca24c178fe6f8eeaa67fc4f0d1fb5a3433051abce"
    sha256 cellar: :any_skip_relocation, catalina: "5a6fa5e698960fcdb23b66cd43f105bae80e1cb7488e3a496836dbd0987fd7dd"
    sha256 cellar: :any_skip_relocation, mojave:   "55fd6eeaff82c03155343f219d1afdc9ac5c1f0e49f0d1a94fa563576a6f4906"
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
