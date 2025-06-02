class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "8e315090e158d6d836cca343cab9e1129e5197a50551abd0d6bec3db0f8167a1"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936d89089c6b77daad570cfa503ecd27a092ae4c273b9cb1303adb87c97b44da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "936d89089c6b77daad570cfa503ecd27a092ae4c273b9cb1303adb87c97b44da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "936d89089c6b77daad570cfa503ecd27a092ae4c273b9cb1303adb87c97b44da"
    sha256 cellar: :any_skip_relocation, sonoma:        "25396d056efe5113d58bf2d3b51380ef9e7e5876dde603a296f65c97ab4adc77"
    sha256 cellar: :any_skip_relocation, ventura:       "abd8af8478fe0b4437a875883ac1e6679cfef730a66082edcfac70221bc805b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efea968d07360f9545533a080de9da45ec4a46d9fa5d83c23f41c0baa855b277"
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
