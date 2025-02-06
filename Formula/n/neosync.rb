class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.15.tar.gz"
  sha256 "a255407a9777cc31d22042505783c080ecf747d5fa977cd86d7b3e02abd6ed9e"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9afe300b3988e64406a7362e0519cb4c3d2b4cdd7312a2b0940a2ef93d42a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9afe300b3988e64406a7362e0519cb4c3d2b4cdd7312a2b0940a2ef93d42a1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9afe300b3988e64406a7362e0519cb4c3d2b4cdd7312a2b0940a2ef93d42a1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7fd77935d683f43681503633a5366ce2b54a57177a3473f0f24e0b6a000e543"
    sha256 cellar: :any_skip_relocation, ventura:       "b7fd77935d683f43681503633a5366ce2b54a57177a3473f0f24e0b6a000e543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36aec726832331cdbd3a075aba89103fc54a3a793a879a72471b641b8606d9d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
