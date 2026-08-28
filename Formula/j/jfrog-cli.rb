class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf14ba68f27a255cedb32349a107c0391674f46f75d0216abe3fe38e9be5ab9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf14ba68f27a255cedb32349a107c0391674f46f75d0216abe3fe38e9be5ab9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf14ba68f27a255cedb32349a107c0391674f46f75d0216abe3fe38e9be5ab9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "816c3d3b1b0d78bfd1218cefe259a9662e3e081ca40d367024c05bd68bf6bbb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b206187fa02dec86a71e1786b9b1f8f0405570c3d9c05396e8de06bf8c3c802"
    sha256 cellar: :any,                 x86_64_linux:  "36eb9273ff95464f6b7c257f11a3a88150046096519275479a8d5cd0faa61a4f"
  end

  on_macos do
    on_arm do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/2.122.0/jfrog-cli-mac-arm64/jf"
      sha256 "3a07043368803e96e909d24b101196a16eb1bfaede809f22e61093074894a565"
    end
    on_intel do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/2.122.0/jfrog-cli-mac-386/jf"
      sha256 "6f48a4c17109ab549543c03703690c49e26f1fa577c265977b3e050e2707e89c"
    end
  end

  on_linux do
    on_arm do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/2.122.0/jfrog-cli-linux-arm64/jf"
      sha256 "e394813283fd43d1da1a3da8d0824518807123cb47f38701e347e55279145dd1"
    end
    on_intel do
      url "https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/2.122.0/jfrog-cli-linux-amd64/jf"
      sha256 "2563d19de8a42ac97c80fe9cac6928364c4a5441074bd09bb38b3891532d5738"
    end
  end

  def install
    chmod 0755, "jf"
    bin.install "jf"
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
