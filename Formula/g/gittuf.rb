class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "537f31645b72f9d60fa294afbd6f223c93f8004d15bd02886ac7436522b4892d"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "addf01163361488d372ae51d5d725a46eab073131dcb506fc1093bda003f3c30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "addf01163361488d372ae51d5d725a46eab073131dcb506fc1093bda003f3c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "addf01163361488d372ae51d5d725a46eab073131dcb506fc1093bda003f3c30"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f9d5fa97cb4c403f8283d7c46ab7dc2189d6ea0e08524e73ce84a499e806fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0def05cb93bf136f1b8f1a03f17b03c1ba26336dc690627fa0f1277be7e84731"
    sha256 cellar: :any,                 x86_64_linux:  "fe06b5d7f4910677de83a9ced9c6303c7a6d399673edbe6f7f9e1b2ec028435e"
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
