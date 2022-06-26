class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.6.0.tar.gz"
  sha256 "dd846f7ff7109921febc8aecdfd769a1258488a0d72b4a0cfcfa3eaac118b1bc"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb2929c8110a79c37f247edbac9356596696f165cc1c06362ae2c4f98165e2a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aec445d2d3c5c65858399da7d080ccfd04c5f31833c60a13552866738efa6f99"
    sha256 cellar: :any_skip_relocation, monterey:       "9c7b7ced7c6761d88221b58fa3d813b8f8fbb4795133e5b74cf9cb43de47de71"
    sha256 cellar: :any_skip_relocation, big_sur:        "4286045f573a729204902e6aa6e87a73fa26ddfe29c22d4b578a845b3a77befb"
    sha256 cellar: :any_skip_relocation, catalina:       "a58d3b9b2b9db53fd66d7b90f452b412ae6d504cad7671aa2da8a452ad8a489e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ce7eb2f4d166d8a22edc9251f91bf6ee5ddd2f5ae2c4d348434fe4c98b930d"
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
