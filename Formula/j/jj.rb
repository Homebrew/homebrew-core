class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "9e8da8ec2951ec026a2afe956ad904bb691c050040f53c3e47cfe346ead2907e"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9754944f643dbc3d72af10999408feb468d25c5a079d29b3ad58ed3ba8a78021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b12555d46ca04ecaa528ca64c8e8479a7f5aab1e12b746356744cf187ec3d880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9d71c32df6c9d47eb72b8f153dbcd7f4616d75421dd028dff80e0dde652bec"
    sha256 cellar: :any_skip_relocation, sonoma:        "4797a880b83b9786b3380b24b3c48ece323357d4bb1262982b8f2189b2d5309a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b86830469087d92df7c51e8938709ede6f26683e5cb3548dcacdf1b4116ad8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee71a76c2fb69e98dc59d402242f9374c3b8fe5146d668689d493d4eba9e43f"
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
