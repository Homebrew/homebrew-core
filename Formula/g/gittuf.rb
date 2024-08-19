class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "0f04fd9e786b3c34599433ed972331faa3518f6be70d939e4e37d4268eaa5619"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b78d7a4639cd1a2a45b60a11fe2287ac27b16e986944009a3a2cb5e14d372ba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f78310dbc7aecf61b6e579eca9f02bd92b6356ee0ac989d781f1240015cedf95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55a9a79ba45dd46e45037b600c52c15aa44ae118b7189036ade1b6882fcd9402"
    sha256 cellar: :any_skip_relocation, sonoma:         "731a4a6df77a7fddf2c014528d7c8da874916b168fb4b0c188be2a5d732c2ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "1314bdb21d09b6bcd79c9433009974605ce28beea2b5f71a78d01527cbc32b70"
    sha256 cellar: :any_skip_relocation, monterey:       "fd4e266d9d123f1f8b27bfb2cac4d801ff4a18a534f3eca32e9012b947869ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ca873cdd73adab226158b8a09cfaf49b51b984d3959d81fefc7be6a609ffe9"
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
