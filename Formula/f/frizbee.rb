class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "71ad0532b478c942b74c53e5ddec45df4b737d4db05192bc899d2ba7ff0a2196"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81268f603d077825e54b9ce23565dc975eacf37631b23048090823d962524a13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3cccb25cf914098b92d2d170231b8ea4ae65a7e2ab325aaa2c834e027c026f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3cccb25cf914098b92d2d170231b8ea4ae65a7e2ab325aaa2c834e027c026f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3cccb25cf914098b92d2d170231b8ea4ae65a7e2ab325aaa2c834e027c026f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8350ae10a806428da912b930be21e87f5476630bf10d2c0fe4d00bbb7f7406c8"
    sha256 cellar: :any_skip_relocation, ventura:       "8350ae10a806428da912b930be21e87f5476630bf10d2c0fe4d00bbb7f7406c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ab85f12053cfac1496011784823d6c9a026d7d2b75c3e06e8aabfce9e9fdb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ccd2e57c9257a04aea350b7f284d8788311f636c071ac3113571b538f5dae8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frizbee version 2>&1")

    output = shell_output("#{bin}/frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
