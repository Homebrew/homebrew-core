class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.43/nmstate-2.2.43.tar.gz"
  sha256 "ea76fa85b89f3621feaf3a0e18d285c274f202276201869f47a206866279b9c8"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53a3923d4399b7cc4172fbae3f819a304bc11c47c22aad71a1626bd0680ef235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b46dc89c9e5887d3ba33e7b3142019fbdbe3c20a6b05e9421ba1f972db685475"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81a751389038195597ef65e5abfbc2e335db95ba9f7ea1ad4f8952bdaf4ed5dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "aff0a105948c6ad3f274db8f993f980cd26a8413b80e2b1c8708013fec9273fe"
    sha256 cellar: :any_skip_relocation, ventura:       "6ec549f49ea2afc85ea5ada6eab7356303aae0f72399e914002f0a5f3288564b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c2b6f380e52a277bbf70107c779d52b5d5c10572ff53403195a965caed04d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca4481eb1ad09ff1b185fa29c6bb08b655f2853b54508a60d31d2af839c2d666"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
