class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.22.6.tar.gz"
  sha256 "f003626eeaf6f20963115653cc9338a13922af8f4f961b1f1ef4c24e9f40caa4"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url "https://github.com/Schniz/fnm/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1bdb065c668202354082100cca945573022aa9b59e6e75e2068c952dfab697da" => :catalina
    sha256 "9199d057fb6fc24da81b55253780f14251d86cb75019fbba30833ea2eca4d0e8" => :mojave
    sha256 "ca941e17a0e0cc4095c41aa25ad90597c447b12ebfddeab681a3ed8d289bffcb" => :high_sierra
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
