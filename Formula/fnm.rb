class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.22.8.tar.gz"
  sha256 "d294f1bd9f6fa75d53c5ba12283ca63a09812d4e3631aa314d781e50e8c9aec3"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url "https://github.com/Schniz/fnm/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fb7a10ca743733c57c54aee383593f6b85027e4a715c1fbe92bdfdfe7b142bda" => :catalina
    sha256 "0616d43ab3fab3194a79dc343385adefefea0b5cbcecee6af9967483cd71deff" => :mojave
    sha256 "0c1674937c6196ace66708e6fa39ec11a6297830321f14b65c1d26360b8d5c97" => :high_sierra
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
