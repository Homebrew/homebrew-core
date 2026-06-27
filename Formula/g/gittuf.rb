class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "4b6647429beed2f688fc51add387e285afd80e075a1c47cec5441c6dbaa17cb4"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69612a277842fa0f7e81ad6250cc3909df1fa13be0f21aed996460160eee681a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69612a277842fa0f7e81ad6250cc3909df1fa13be0f21aed996460160eee681a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69612a277842fa0f7e81ad6250cc3909df1fa13be0f21aed996460160eee681a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0f99d5fe5bbb44cba8da7650344e90cceb98e857a17cd5bf024187be960195e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b5a3521f4adb525293e2a5b16ea7563f654030412c435078768801fb8fcd6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deae800e44d61d5231621dabb38900b78c4fd9bf921b087357bec9bbf81da485"
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
