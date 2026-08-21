class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "7dd746c4e7ec33975db01b5593fb606cfbb414b8a4b43cc741efb7bd1804d205"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67d5fbffca3e5e2afb1e8039a8cfe619cda96cbea8fbe17c8b7bcbd2ef61d131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3cf1df4984e0c82c879c7ab293a5159c3fe16987d75ec01c703b9c9f3d5d8a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f6ce7dba4a1cb9f139d68eea031b96b69cc8d829b38df098578620fe58e655d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c04f22def92c5286f324d99925c1486a6a6f99815b394ec7a53fa997c19d5dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0abc6ad4ac29a014cc23e727821d870280dd60d9e132153b7f7fcf39d2a9a4b8"
    sha256 cellar: :any,                 x86_64_linux:  "cde3e0566708b6449d46b7e4332d845411c52656ea575b78ba5dc09afbcbfc37"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
