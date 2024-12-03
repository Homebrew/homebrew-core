class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.6.0.tar.gz"
  sha256 "f4eb80a88b07d97cc237288ec2b816fe5d14861d42291f406368718bb11efd58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a0e61d020fe255cdc963ab183fe0683f16a33d1d920f3067d33c22c100c30e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75096bc21f45a6ccf9761bd35eff0477e652ae403eb45309e0827a490541fbc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc2c5258e9efb31423c82d417dc37a6d0c9a0b776a3acffe99d8db36b30de8a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "49747dd5476d4fdebc696ccfb52ef2e77e81ef218ea772b9e7ce9a2c073ed01e"
    sha256 cellar: :any_skip_relocation, ventura:       "121c1f4b4507c9e8e0f04fd7f1efbaa34e24bfc2d6a84fd6cf27b2fe3d5064ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b31b3c1e505e50ccaaab4e95c87e771ccab0d56c303ece9d8c486e8decbc9896"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"

    generate_completions_from_executable(bin/"ignite", "completion")
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
