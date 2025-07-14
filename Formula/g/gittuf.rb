class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "3398a7eab1cc620db39687115683198bded36540d628742239b4d93af45cbe80"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "188b3bf3b5350963833378bbd9ec752a8c6b1f9654258005889f24d2c94eb060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "188b3bf3b5350963833378bbd9ec752a8c6b1f9654258005889f24d2c94eb060"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "188b3bf3b5350963833378bbd9ec752a8c6b1f9654258005889f24d2c94eb060"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceaf2408fb6adc5735c2fbebf008e034dbd50f85ce4d9895e24924390d047362"
    sha256 cellar: :any_skip_relocation, ventura:       "5aeafe5344a73294a6532e55e21e6f287c41b2a9140946c3fe951ffd7f8f19e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f91f807d9ae091139a64817a9a9aee58aabcfe903edba6f8130e487e94dbc11"
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

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error: unable to identify git directory for repository", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
