class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "637f50756366604d4d19a6f623cfd490c38e1b971708ec8ccdb39887a0e9c1f1"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0372ada46743f9b0a26ceaa6d7ed9e7cec24bf6b9f4e73a43dc35f653a697bf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2405a0f0e068cbaa41ee26104fe7a2a51a5c7024f43a98963a3d12ba9d790393"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d616bf9770fb2318dc96ea4f78eb62457d13b0baf8570b19b0a4ba903f3da2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "166bc8bbedef0375b19638f9075a0e8c1b7050721569c9c25bc10c2bbfd9892b"
    sha256 cellar: :any_skip_relocation, ventura:        "d1d5f5576474de0a01e262e4780d342b07bb0f1226fd53cc47596d2735a29400"
    sha256 cellar: :any_skip_relocation, monterey:       "98603742fabfca02e780d7e0b96334c331b859e05ae07fe28496ee9b4149a068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bacc298e3d94f1934a8ab54aaabc8e08cf1cd0a89f7a01566b2c364b2d13e622"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
