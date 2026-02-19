class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "c24e4c26183a4d88a33e343902ed2d45da23e78c66b2a696a7420eb86deddda9"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9d89231ddb338071a739ce0726afab19579fdc8e4eb10f47cc272fd95be9a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d181b9639018f4bdae1697761c4206cb00e8761e3840a376aa03a0852fd1de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4a0ceb3cc135193d06217401c51baeddbb7feb5f18309f9ef907cd3ad0344a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6d563c6f1aa3382253d908cf245360a4240bf3114b9eb32b6e13507722bb3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f5f592a6555b13a3d7fb5c5e9d851bc7ae5a3b24481f2c3df9cfea812c2cd91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c89e2291a47df638eef0d32c133347f216d71133d15f764a09d213b91f4ad32f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end
