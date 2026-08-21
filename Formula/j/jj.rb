class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "cd72ac1040c93d474dcafd8dd7f8d91d7407f9358bc9ffd4a6b72f4017112eab"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4405aef0453066b76d7a157d824af3c4a42a421c3b30ca810920e698a283406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e5efcb89e348b4028e1ead86dbe22f0d950a641b0fe48b5efea7b40dff12ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c5d7b84a14be3d6d317fdb0b8ee6d776965d06c0892b5dbf9e2b754af31cd69"
    sha256 cellar: :any_skip_relocation, sonoma:        "8550065b0c2387398677b5c8e9c0db9d1dc8c79e37903ea8604be181fe03db20"
    sha256 cellar: :any,                 arm64_linux:   "ab6521524623c9410c99402466138102968c3ad0cf38f637950d9086d329e87e"
    sha256 cellar: :any,                 x86_64_linux:  "b311b35e51773d5a6a3f05577375921ff8980cac5dddac99f01ffe6572ce8f01"
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
