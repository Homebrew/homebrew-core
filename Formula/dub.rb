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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cccc9ceee9ec8c4b9862e0442c92f426a2382d7a8312e46b56f71a94cdeb640c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2d4071b7584a465ffe9f200352d461803d3d7cf27bfab801018cbe1c9ea1542"
    sha256 cellar: :any_skip_relocation, monterey:       "9408c7786db9c860425b00340da19ea6863edaef9acffb63feeaf5a5804d1fa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "440f2e41dd346d764059e952079cc2f940209697815ff2804f917dac395617bd"
    sha256 cellar: :any_skip_relocation, catalina:       "d65451e626f8fb08f13aa92e483dedadcaa616868426ed3e9e38c7de59e19a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493ad504e56b4ba4d1d3adf4887a40d8c062271a6f4127ef1eee85b9f900ccd8"
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
