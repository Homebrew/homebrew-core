class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "6b5e5ca939d9a4140e966bb14de64ec6e711141c70e373080b3ae5fcf2dade52"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b3d2bc52d3e6e81d7f4a753c7fd271db12e9e2217f120b7918fe3132989cf3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe7fb32ffc6c0dddd2b463249b351b3982965d7b9509b7004ce69055b11f065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2d19b580cd807c9f1eaf4062758f1a255af510ec684898e69c5069e2be1fdf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b979b6b03fa0e65a61ac89c62d539f5f4e0d654a10caeaf1ca5bfd73e3639ade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1440797f2c13718f9208f42a921e3a25c0f1c8d1a8cdca31b0883007f57514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0549dd7a9aded4b5d840f4f3b50efc433339ea05aa474908798e777b0729e460"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
