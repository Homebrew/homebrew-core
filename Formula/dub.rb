class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.26.0.tar.gz"
  sha256 "53f32a2d4c933bf5743778b710c424f8f0bd0393bb32dc73b9756cf10750ae43"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "7414a40c941f02d51ffd14a7f9aa9545ce58a7c39ad6ebb72a13508064a5369f"
    sha256 cellar: :any_skip_relocation, catalina: "bb85f781678dfafcb2c9d183281e29a488b3e7e3921f69da4a6ff152959474b0"
    sha256 cellar: :any_skip_relocation, mojave:   "e8907c0ef61417362b32f14361536d51d6a78eb52f5810c6b3a58757680ac611"
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
