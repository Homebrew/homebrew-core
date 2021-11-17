class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.28.1.tar.gz"
  sha256 "9c05bf2cf3f43baa197eb3df582efa2cde5eaf66e3b0446a78e0fe6e46bc23b5"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "905fc55c51ec5c1dc889d2dbce5fdc30fc918c0f463e2319df290cded53ec08c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d403f455797499a498701bc6c61fd2dcca33af9e98957b94cffcb3860d53f8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "3549453c5e717d8699cb0e39f8d92ce103f0da419bdc08236fb7b1843f20fa1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9649b950701cf4528fc2ed2706e8b3b50dbb731f94439f4add800fe7c66f5787"
    sha256 cellar: :any_skip_relocation, catalina:       "37c025276645b7743958863e93909660f4b45838c5e99e2d031ad0559c34076b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b675c9ac0b44a51831efccf9194338aefaab39bad80d8df9f3a74632610343c"
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
