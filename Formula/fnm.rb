class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.31.1.tar.gz"
  sha256 "ddb7bde503ef990c95c762863f4c858499f17c00d8e6ded7885b4fbbf1600250"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b2f62acf15c6c49bb10078746a31a18a6d8ba221573220a7a89106403739acb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a87633e6d50fda95e014d5c793372df09ecd5b598d3ba4eb934ffeecc7b5b8a"
    sha256 cellar: :any_skip_relocation, monterey:       "aaa7b8221f3ff912e67b833d513135504de8f3e0c56fd305331e31715f7fecde"
    sha256 cellar: :any_skip_relocation, big_sur:        "71f2a225d25415e0e17ad7e4ebc76378235791193856619aa3ecd0488a163bd7"
    sha256 cellar: :any_skip_relocation, catalina:       "bb3d424ee314363dfcf7ce539d5d46cfc9685656f62cb462a82f442bba0c1fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b88beb83bd0b3fe707984a936ec643e225e3938738e0f8cdd8faabebbc2f3d4"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "12.0.0"
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end
