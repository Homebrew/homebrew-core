class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "f4fe8f15ed1b65ac921ccec545d2a637e88a239e4262f6c7f1479dced681f188"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a8e6ce9b3776827d0fb9b75eadd078ab1a653007f2933a7e30f8be2999c902e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46053c949a0c8689aa86e76ba82c989d9d53bfa1d67ed956d709b9b3bcc1bea0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b63e717ff808d11dd07d24b30b4084d874df583efc7b06d6334069ae7a65e63f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0171838592b8bcc725042e3c1981e2fa023c66d751a294f01cb6092da73b7c44"
    sha256 cellar: :any_skip_relocation, ventura:        "e2050b37ad98a3ad9040bbc1f5de9bcd8d07d279fa19d0c58fa45230108f463c"
    sha256 cellar: :any_skip_relocation, monterey:       "f1677eda8153e16b25a2516c7db1e9d4aa8062b3a4a6d0a3f56bc2f93969f5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a88488198734ce74c72f85eac0a1f8446a29a2690534c7d05010ec2155dc428"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gittuf", "completion")
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "signing key to use to sign policy file", output

    output = shell_output("#{bin}/gittuf rsl remote check brewtest 2>&1", 1)
    assert_match "Error: repository does not exist", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
