class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/releases/download/v0.17.0/gittuf.src.tar.gz"
  sha256 "a3fa3cb08baa4799d7d2a70691cdc803ed7d26abc77223c132803ff622480996"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc03b460d2e8c61655bfda742dfd21155a2f91b8436249931058f2accdadbfcc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc03b460d2e8c61655bfda742dfd21155a2f91b8436249931058f2accdadbfcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc03b460d2e8c61655bfda742dfd21155a2f91b8436249931058f2accdadbfcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "432d4f279a7dc2136b4a31aa8cffbc52ff0c6fccbd821a1da3d35f380790adfc"
    sha256 cellar: :any,                 x86_64_linux:      "5ad574624e89e3977121deb78b17717958e1f7fc416d6bee72897efa63c0cb5c"
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
