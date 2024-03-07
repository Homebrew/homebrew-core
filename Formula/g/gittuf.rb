class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "508ce6b396dded2391fef0657922fb6310ba52abd1e3dd5a2dcd79abc6cd5d06"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422bc5e9aaf6286a164d2f437030f0c6bdae87a3ced3d4b33b0ede8b8e28836e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ccb6feafec634ad826753f379ca5d65cf96accaacf8043db64ee02ed23c0a11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e72d05dc2265aceff99dede521026657b4702fa4e0d32289a29513459bbdd9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a1040b7b2893ff29dfbc007cc7dc9e80603a1526393a13edb9c29f999cc7740"
    sha256 cellar: :any_skip_relocation, ventura:        "2d2f690a557b979bb1bc9bf45e48640c545b96c0c492fe7a1459d88a5dc1bfdd"
    sha256 cellar: :any_skip_relocation, monterey:       "322fbb558e8712296ec764d56e4b41ed577eb6e86697f1578f060385b8badc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83c782a7ec5229eb9d437437e46955c25f33a0b0dbafe51bd92c123e2d1d56a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "Error: signing key not specified in git config", output unless OS.linux?

    output = shell_output("#{bin}/gittuf rsl remote check brewtest 2>&1", 1)
    assert_match "Error: repository does not exist", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
