class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.62.3.tar.gz"
  sha256 "f97c8412f7c5f74a348fe011f84f5926153d23475d875e2dc61ddca30872e489"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d4f2bd91baf8703367802e7b6cc904d539bbc9dba95e950853ee3a88f03d819"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73320a56686bf12bc83ceb6fd9520d707b59a939c0b080090f750c21718a2b5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "979aeb43cdadc3cbefee7dfe8d116ea3fb8cb13f3596952a5cf03a3914f5a85c"
    sha256 cellar: :any_skip_relocation, ventura:        "1e437f658f524a9a16a7cd07b275e12270d15e1bb7409af4edf2454e63d722ba"
    sha256 cellar: :any_skip_relocation, monterey:       "87226ca951a48da88cc799db0582ce80c25f2109158f2740afe3695070ef4d00"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbc1768974bf91ed396977157714790aeaa59bc929ebf2ae0c46e4df2c8c903f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e8a3d319f0b0698ffd247b5d2b79e09722e22086a54f4dd273aeb8206fc172"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=brew
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check")
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end
