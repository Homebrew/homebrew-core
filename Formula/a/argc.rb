class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "3c0756bf455759617f2ea0405697d655af15071c89b35a58311e4be53dced1fa"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97c0c11c5ae6a02e1d03a5517d20212f19ea2b6ea375240376edceac4e648b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db910665a850a7cb9ae004905334f5ee7e59f4d2a6b6fa6bada7f0726504d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd3931b38e249a10a4bca2fa1915dd4a703f481bf274d8a5f7ec4a2be41e17d"
    sha256 cellar: :any_skip_relocation, sonoma:        "247198700a139a3d8a0271bc76255582f5faaa51e41eafc2f5c7b33246b5c5ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4f46f3930acd606540638bfa9e2a647b17c658404d8b5a02a5d76ca9208c0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7799c43dd99a8ce808ff49e11e2c864a2bb4f4d9a23797f39179d607bf2cd8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_path_exists testpath/"Argcfile.sh"
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
