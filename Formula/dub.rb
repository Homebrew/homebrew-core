class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.20.0.tar.gz"
  sha256 "aa50d577f855b955b4236a4b06acc33a9ce2188258156d920b7231e30b386d01"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c0bfdae49c9965b7f90de50486b04933f794c9166ef816f21f53ef2b22d85df" => :catalina
    sha256 "b5b8e411a9056b4aaa757fe05437315866bcaad6545d30a776695ff2349c2fa9" => :mojave
    sha256 "728ae6e6ecd2f320a58da17c6a10956d34b8c9ea7311eff9b39f83cb3398b8a4" => :high_sierra
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
