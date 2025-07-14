class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "278b9cf8293616c511b86da95c90358fa11bfef09bd5339c9914d4dad027d9e6"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b66d403b70193a8e73f9f3a8cbcc5160a5755bcb70219c900ba8041b5f4663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b66d403b70193a8e73f9f3a8cbcc5160a5755bcb70219c900ba8041b5f4663"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9b66d403b70193a8e73f9f3a8cbcc5160a5755bcb70219c900ba8041b5f4663"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e94fb55acf160374b5baf590692101fb83f00194a475209526e21ba353229f9"
    sha256 cellar: :any_skip_relocation, ventura:       "78da3fdc36850ed1241c0de248ab03448bdd8c991ca912369efb7a3d986f7730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c876088f3f75bf0efd88000d368907856441f34fa588af161fa87e0885ba6903"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end
