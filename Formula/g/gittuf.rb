class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9d585a595c114c51f201dfbe426a52cc54ed4b1168cea03aab1be4bd6a61ebee"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58f692d79b634906ba9b5412d6dc003b2f79917d9d981b7a23837e9e1ca8b10c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11d5813c07c57ac911f968aea3049ea47a0bed60c96f6cbacf4bbbb24e70e877"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c24396c2d4044d6b8497f4319490553e6e4d5f8d344c4535886327ce00479722"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac2de4567cba9e0fd06e9f4fe978c1ebf31d3e8c27d6151fc032b577402b3c43"
    sha256 cellar: :any_skip_relocation, ventura:        "949a66e8c029dc1d47a4a8c5618f9605cfb23a59c15620739409de6511322b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "3a20d87a9749e13d463bc62cf0a0696f640e5125cb7c2f5f5f3739f863725bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbccc683e10fa7372c57b00d0df21e53f4527490719428031c191de4b0abc096"
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
    assert_match "Error: repository does not exist", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
