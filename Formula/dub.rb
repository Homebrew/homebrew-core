class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.20.0.tar.gz"
  sha256 "aa50d577f855b955b4236a4b06acc33a9ce2188258156d920b7231e30b386d01"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cebf3a1f606c69d667c5c4214fcadb9b64e2222bb83cfff946c4e8df81e8f0e2" => :mojave
    sha256 "48fe0094c432bbf312f12c3fbf4d73214a41b4a0cdaff8ef7c140d67bf20c133" => :high_sierra
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
