class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.308.tar.gz"
  sha256 "129badf38e3a66e9ca0f8f7f518ff9d8d06bb88a7a6a38c2acf7a729cd421ba7"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13463c4142ee0116c444901995d1cc1289ce018a485cdc1053b7bc80ec6fb5c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13463c4142ee0116c444901995d1cc1289ce018a485cdc1053b7bc80ec6fb5c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13463c4142ee0116c444901995d1cc1289ce018a485cdc1053b7bc80ec6fb5c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc1633e3374b1dfd4bcbbdd8170eae7ac094732f991c2adf2de1f657bf5aadd4"
    sha256 cellar: :any_skip_relocation, ventura:       "dc1633e3374b1dfd4bcbbdd8170eae7ac094732f991c2adf2de1f657bf5aadd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c8d8e9b835fc47fdc5605a1c9792b1408d7c369a185ab850ac4256caf9ae44"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
