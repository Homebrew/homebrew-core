class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.27.0.tar.gz"
  sha256 "e0509c768be40094f01e0cee903d0ac2a02c064a5987c0bbc7208996686b98cd"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a7b6d36aa0cf64fb42f99a57686c7e771690b6b97eb19f6e65486365b9e262d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ed1913f1c9f70bcc703bac59e9e46540cb2030c5e42e0fb8cfe42eb1754ee75"
    sha256 cellar: :any_skip_relocation, catalina:      "3195625f6b556c8eeee0894ba516b7a91a7fddd1fd31090867b942bcb583e917"
    sha256 cellar: :any_skip_relocation, mojave:        "9921bb97be053afe96cb9a18bdcfd95fb34faa9a00dee89d0735938b52ea0a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a237dc5807cb312d8cde5f0d937046cc10a4c58d3d941d82064fe6fa49f0b96"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read("#{bin}/fnm", "completions", "--shell=zsh")
  end

  test do
    system("#{bin}/fnm", "install", "12.0.0")
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end
