class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "135bf1df883a7f50c96907d87a246ec9fbe885d2d4fe4d1bf7d34d98dec910ba"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318a1ff827a888d5c7b656f6faee25703ea634b5dd248f7656d3c52a183158c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee3aac7f321985420e9656f3ee43984629e3423de7fc2edba1730a7dc1ed91d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab8e5dff600befe603c5595ffe099b3c91937562bcb3562b320e886650a50c31"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe25f6f724570371473429eff988bccf292275282796ea07091210b9fdced7fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2149df44145d6825ffcab4b7bede25e696ea78dd3c02119afb7be25c41b850cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4731fbf0df26b0a244a6175d175a01f9cfccc90f7cf9ec79bab6430f247a73"
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
