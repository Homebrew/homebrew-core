class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d5b8051fc418494e6b02db03fd482433ab64ddcad93a2aa2573ffadf0f53aee7"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "780751fd2e61c4378768cf97ff5cb0fc4cb819c5e3c088368f25d857ce284fff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "780751fd2e61c4378768cf97ff5cb0fc4cb819c5e3c088368f25d857ce284fff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "780751fd2e61c4378768cf97ff5cb0fc4cb819c5e3c088368f25d857ce284fff"
    sha256 cellar: :any_skip_relocation, sonoma:        "286113a86e3de1317dfe4e84031f7c8aec96bb8685233719c0c365675a9698e3"
    sha256 cellar: :any_skip_relocation, ventura:       "1a1cd3b46cc700a9f6cc6639b3fb7357d6057c5a2e9b939695b2058b6a73e26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66995d2afed8fd634a999b0f6a210a2601197f169bdad76320b917d064279f22"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}/gittuf rsl remote check brewtest 2>&1", 1)
    assert_match "Error: unable to identify GIT_DIR", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
