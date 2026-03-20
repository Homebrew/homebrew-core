class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.17.tar.gz"
  sha256 "94603fe634bcfc71a896fb416c21315584f1309396808ef8362b355e439509de"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33a652feedc4cd54e5b8847a0b34aeddee8227225658ee6fd6492d7551ce3e97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a652feedc4cd54e5b8847a0b34aeddee8227225658ee6fd6492d7551ce3e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33a652feedc4cd54e5b8847a0b34aeddee8227225658ee6fd6492d7551ce3e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "d84a337bf86423020a091ee64abef100c3432245f007c79aec073a3afb2a858f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf386bbf974a853d19aa9df9bc26e3685329f67b3688842a0b80f9d76d19028d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f293c8c4f50bc4b4aad6dfe97593aca5c83c0b656e58c9602d68a56eb096e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
