class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.22.tar.gz"
  sha256 "58f175b0c6c38f11090fc706d0bba46f446f12a92db5950dfc3457e71c58c333"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8862f6308a03db033612ee6e8ebc5a3110b26e004eef4cdc200e8a82b881b0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af97afcaef8be7d1e90e65ed0c7e8c99122575dc343716a5e23901ccafedac33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d30fb66d215b5ce58383034f24023b576b56197dc012495cb8d963fc1f61b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d70e39d83dffd4d5d85fc16edad88b1cecb0585550c79be65a7c17a20bf8791"
    sha256 cellar: :any_skip_relocation, sonoma:        "44dec713e67fa0b4873010ad654693bb853b8491e95bb99dec27716aa816dda3"
    sha256 cellar: :any_skip_relocation, ventura:       "e1d946c7e2a05e4ee72e26e7ebe01a39f06e9242970b9fac3052717a876b54a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38e169d1cf9c10df60734a60917910bebe757d6f02fa74ad3bfc468312e84001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a290476eb5dbf8a09cc4d21997e28dd0084dcfa4df537c8bf8196606223ce3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
