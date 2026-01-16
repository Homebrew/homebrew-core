class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "af0513ed0f1d6aa1c6ee83cd5432f6e77db8f7c7ac1b7244612f1e26895688a0"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44dd77eb7382792516d09d4e823ab2e3fddfb93e17ee5837b9723cbe95de8a7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fbaf7f93ccffdea72111de8a8329059a95f9fca57bcfb7f27cfe799042970a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e63cadb581990c68ab6967e027497665a4fdb83de851efdf5d48abedb3a9ec1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d64c604abec84e66ef46186bdc901c2eefeb773898075563cb0896e51579495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80ae9db74d0a0e7146b751c817d874d467dc6447a4075374b12169ac5fc5a7b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5a40f0fef59ed457161bcafb7e683adc3799fb863bb3a121e27c9f0f42faf7"
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
