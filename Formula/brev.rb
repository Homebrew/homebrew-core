class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.229.tar.gz"
  sha256 "2f5b4bfbf705bfc92ee46a0a99a76ff914eb134a08027982467a409e96a8d423"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f9e16441f8683e44d137199860fbb6ec2c6063d07d36cf20fc71e06cfd296a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eba470f5ba48950b2fa4e4a904dd0d5238a1b3ed056369c4110c4899b51c9f0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "581ab2ca1c6da5229d5e38bedd6ff2e06363ccd09bb98a3c6012ba2d412f6c90"
    sha256 cellar: :any_skip_relocation, ventura:        "961852fe7098aada567aac956941ba7ba213e318df2b6ac20f66a0aba6c3fc0b"
    sha256 cellar: :any_skip_relocation, monterey:       "471eed414e1cb3fc70103192d2c28a47e503feaad455be53a36fc20781cf5a09"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7bc1bb250fdbf5dc90d2189c0e2a8572529ac2252cf3fd64dc8ee4dbcae325f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bba7ed22c4d8e92db8b3e8032bd411b527f0548e23d97413d2cc2b3e4643ef6a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
