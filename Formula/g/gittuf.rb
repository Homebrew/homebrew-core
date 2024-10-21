class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "8fd7a4dfef419a87c0cde55bcf155f399587b0dfbeb4be8d85b0dddf815803c3"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3183c8276427089d5df15b0d8d6740337c9bd4a2c417488004338054196746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3183c8276427089d5df15b0d8d6740337c9bd4a2c417488004338054196746"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea3183c8276427089d5df15b0d8d6740337c9bd4a2c417488004338054196746"
    sha256 cellar: :any_skip_relocation, sonoma:        "4738b19cf3a71cd477f642775a0ed28b94ada090dc1cd4bdbf27cef723b260d2"
    sha256 cellar: :any_skip_relocation, ventura:       "50554151a28d7a6479de482ecac9afb786c9fed2b7de88e94d65d1753e4c0ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac99566029b1476a0eaf828a7019fad6a05d7cc5407a9e4857ae1927fc53293"
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
