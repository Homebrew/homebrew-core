class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.13.3.tar.gz"
  sha256 "a408722a6541800a67e4ff227ee9771b95299699e87390b33b334dc08081e9a5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59f17593c12bbedf2f08ba2e9dd00de5288c5c2f936bed2e3a9f5a0be1604726"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59f17593c12bbedf2f08ba2e9dd00de5288c5c2f936bed2e3a9f5a0be1604726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59f17593c12bbedf2f08ba2e9dd00de5288c5c2f936bed2e3a9f5a0be1604726"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b10cc4655c313c93d89b597dc552525ae7626790be05709310ed1de56a96486"
    sha256 cellar: :any,                 x86_64_linux:      "9e859bd73faaca5a69cccfac7dca3a79486cfe05e5cbdd99d22084e7e1f919cb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # `go mod tidy` needs module metadata beyond what `go mod download` fetches
    system "go", "mod", "tidy"
  end

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
