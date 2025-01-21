class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "3aca6e86a27fd659f2c543c3516a50ca46d1e6b0a85df5363d90e792dbf90f2b"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c25d69ec52fab8fa9cbb339aae62c8d4072853e33d779c95cd5f9e146aa6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c25d69ec52fab8fa9cbb339aae62c8d4072853e33d779c95cd5f9e146aa6ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46c25d69ec52fab8fa9cbb339aae62c8d4072853e33d779c95cd5f9e146aa6ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a4435d62f083d5e20b0893ef8673cead2aaa27a5c707ddc988a153c9ca885a7"
    sha256 cellar: :any_skip_relocation, ventura:       "0a4435d62f083d5e20b0893ef8673cead2aaa27a5c707ddc988a153c9ca885a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a36516da0357fc73d5d8398854ddd467d808f1d97b5ebf61b21620f38b6cdbe0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"frizbee version 2>&1")

    output = shell_output(bin/"frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
