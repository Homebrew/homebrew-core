class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "d58203e781a03eb1578f4d5fd411bdbb7d6cb71e4abe5beb577333ac4ac7a578"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0cbca8a270e3e763b60c2fdf7b08d2c9d8ecfd967d4814265cb390c3760b522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cbca8a270e3e763b60c2fdf7b08d2c9d8ecfd967d4814265cb390c3760b522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0cbca8a270e3e763b60c2fdf7b08d2c9d8ecfd967d4814265cb390c3760b522"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff7cab3e7c45a9750e6203f2f777c26e3b7b29bebd39670dbedc80d3fe29b5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72685135a684f60f2b26fca40f0ff15420cb2aca892d0ccfc8bb11640274481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c0d7606659829363965dea99cc65fe5be2422268950f4b0455ac932f4cf0c79"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-remote-gittuf"), "./internal/git-remote-gittuf"

    generate_completions_from_executable(bin/"gittuf", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init"

    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match(
      /Error: (required flag "signing-key" not set|signing key not specified in Git configuration)/,
      output,
    )

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error:", output
    assert_match(/(unable to identify git directory for repository|No such remote 'origin')/, output)

    output = shell_output("#{bin}/git-remote-gittuf 2>&1", 1)
    assert_match "usage: #{bin}/git-remote-gittuf <remote-name> <url>", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
