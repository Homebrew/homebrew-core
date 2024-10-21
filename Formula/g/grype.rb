class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.82.1.tar.gz"
  sha256 "e8ea8432145115412d8eac01aa23579037c5af20662ebfb04947ed74907a5bea"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc64b159cb8a5fd06cd45566366e2f882653927eb6e2494f6732cf58a8de394"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85341ccbc6b94165a8c6a5fe8a761852ae4039a39238a67c3a4c15bb6350ed7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91910a97df23a2f6b2d332c577531d1d4d22a13449cc0da9575e232ab499d8db"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e09ea1fef7565202df11a1953c4b772f9b616bf17be148d26bb26e75d23600a"
    sha256 cellar: :any_skip_relocation, ventura:       "c03a1bc7c6f9e1d0c9f3d428a45976ef7e06715bbb4f322a36d4cbbabafd6557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62074ae6e846792dd3d106ef3e1070cad1d644e45ab583b0692bf526d9d6cb51"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
