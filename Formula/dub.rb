class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.28.0.tar.gz"
  sha256 "bf072edeedc6761fe407aebc55cb9ab624bd61aac2611404990717c2be00ca66"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a74cb46fb2e1b14261d877c8c1c3c492f5ca9cb333f1be78412119e957d7f81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20c67d16147775d49407fae421cef74e323cef53dab0a663b562e9710cde031f"
    sha256 cellar: :any_skip_relocation, monterey:       "6bf803ca4bf4b379e42a3790a9cf8e2a42e81252479097fdf2c9553b4e3488e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "522469719933702ba030cce31f83a4f19638e17945efce2786eaa6ab29b38d4b"
    sha256 cellar: :any_skip_relocation, catalina:       "a708c2b342b00718471ec8427e56f7d36f91d1029939469110ca830d0a961748"
    sha256 cellar: :any_skip_relocation, mojave:         "5da8b64546f9436fcc1210c7acf63a9f95a2c300b7eec8192610e3ec25d7c124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f60af34e8faf094bd0cfefedcad4cb7f5f7fa71634c9dad21229d44c693f7486"
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
