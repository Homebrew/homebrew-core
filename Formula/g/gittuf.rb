class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "0346b622ab1d4790e8adbe21256518e185fcc2bd379d5448b03662d7301e988c"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1131ad7d204dc211f4327a846ffd8ec9f9129cef7a5824b22d3c519d98506a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1131ad7d204dc211f4327a846ffd8ec9f9129cef7a5824b22d3c519d98506a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1131ad7d204dc211f4327a846ffd8ec9f9129cef7a5824b22d3c519d98506a9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6226a8745ed006d838c437f244e6ce96490f365e227af7b7f782e617ed666c6"
    sha256 cellar: :any_skip_relocation, ventura:       "ef1e87bffee157892fcdf68bfab537bb3effaa21896ca08e998e9089f35bb9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4415568133b0eebd11f73a426afc95f0a423d7b0a4dc3a974ec6dd9324caa139"
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
