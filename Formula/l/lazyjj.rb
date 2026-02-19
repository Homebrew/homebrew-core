class Lazyjj < Formula
  desc "TUI for Jujutsu/jj"
  homepage "https://github.com/Cretezy/lazyjj"
  url "https://github.com/Cretezy/lazyjj/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "34a702d55ec4c5d0ca016d4f71f4061ccca347ac88c80018229f6cf50141e208"
  license "Apache-2.0"
  head "https://github.com/Cretezy/lazyjj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c7e851a5bddfbceb3bd566d77745bf5ac11ed2b9d5d46a8818dd0393aa95e8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ed3836f114f0532751221dfdfa587c024ee3d2744122e432134b61d00a7fe11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc9af5259b9c06bf516af13c9093f49f9b9f7205de8f5de14109b947f67de3d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23134bf49a95b53f0e8a6e66f9e9b1d668152b03ff851ae890938720a49407d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d974fc54a97bc59287f4be8dc743f0bc333a892c51ee2a00a0b267aec6fb123a"
    sha256 cellar: :any_skip_relocation, ventura:       "1924e3d0562c7094f55e29a0d214e7d114137a78a1da6514c6171a119720e649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adba3877089a9cd7b45dd398b8e16e06d2f62db3d6297d470f9bc13db7541cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355ec9f7c70a53c3f9b80171821709738cfc7e9bde7f38a5498f537a9d6c6811"
  end

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LAZYJJ_LOG"] = "1"

    assert_match version.to_s, shell_output("#{bin}/lazyjj --version")

    output = shell_output("#{bin}/lazyjj 2>&1", 1)
    assert_match "Error: No jj repository found", output
    assert_path_exists testpath/"lazyjj.log"
  end
end
