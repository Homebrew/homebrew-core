class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "ff40515de7a5adac267c64c0163b38990a74a71bb7612a898832c812a81070b2"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25fe173fe5db2c870b6627c29de2aae7a82fd887e7cb73a69b8e74e068a6c45f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08fc790f702509a003d69984cc1fb31fd2d169f0bd5c2ace396294cfeeb88885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d587c9493101e81955bc96c0301bec22ffea972baecee4d361462cf3c49cb3b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5cadbe35d68dbce19b6efd793a9b36b426ed8cbf66cbbe253ee68034c52ed25"
    sha256 cellar: :any_skip_relocation, ventura:       "041c55765324cc2a66a544cc19a2f5c268d9f9a614f3671f9d9d1e3d26801be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cbdab636cce04dd0c49e95cb439bb74137c7f666514ae1012313695b9693851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50191ce7210d1967ff649d1a7477a399acc45d4c8e05a3be0e30cefc253ebc24"
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
