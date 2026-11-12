class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/releases/download/v0.18.0/gittuf.src.tar.gz"
  sha256 "feb0b809fd9deb6a846c1839e714a2739b7219241fbc2c03ba37b3fdfcef4cc7"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bb9ef84ce28d3933c1fc0e62d60d4f41f9bdd10b9bbc4ed9dbcd9330252803d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bb9ef84ce28d3933c1fc0e62d60d4f41f9bdd10b9bbc4ed9dbcd9330252803d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bb9ef84ce28d3933c1fc0e62d60d4f41f9bdd10b9bbc4ed9dbcd9330252803d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "920abefe07ce9ea04044fffcb1babe91ca590f6eaa162497afa79177f9355b86"
    sha256 cellar: :any,                 x86_64_linux:      "7d6902887bd52373ff3fa706eb4fa043d7e2e2311382570721c68b1fad59114e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
