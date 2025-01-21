class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3d85ecc16fe64d58805558d0f7ecfe3c38533f8d145b1b57cad23ad8e40203c5"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eb976a15664e9e7a69eceb526742f7728952ba8fe3ec73c3c34054a3a3742f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eb976a15664e9e7a69eceb526742f7728952ba8fe3ec73c3c34054a3a3742f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eb976a15664e9e7a69eceb526742f7728952ba8fe3ec73c3c34054a3a3742f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5d3f803dc139e2e246d4e01e85f4c68d9145a232551447cd6d14c3ff866b07b"
    sha256 cellar: :any_skip_relocation, ventura:       "49e2360bb36366271721c7910813b52c47dfe0d67615afdaac759fa79829f247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104c5b69e5c6ac476e580ee00fc3fa7524de806fd08ef092d51fceaeefe67b81"
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
