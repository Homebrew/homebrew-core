class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "cbaca700490de894018566e84c0de462afcf2d2aa8333c70f94dea823c5661f2"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b634ebef83e454e4dbf89743dcb5dce3fa4e1f602834f8edce53710e5c44ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23bb875c1b655aa69dabd7e7a123d1aa96e7c7c05fa7da692f939ee3152caada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306acfcdc1c521b67f41385bce2224975473e7a746e4faf2e216e4ce496f450d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a91ab91b274f2539e4f175a1a5ec5cc9efe122f420d1aad560c34828aa5abe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c473db9da0eed0afcc33f1054a71f597c5e098bd6a83f391ed133dad1a61b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af1a2755f4d0f6912d61a13ade5c14ee1fcc33ba420ff78f992c7ff5377140f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
