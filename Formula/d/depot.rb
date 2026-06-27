class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.65.tar.gz"
  sha256 "69d6b034d82720c1baa1f9e0bf52113cbd78f3184447ab782a6a454962b0b48c"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a998523ef044009b799c6fa3fed05236e932462114ae9ace19b82eed1de9557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a998523ef044009b799c6fa3fed05236e932462114ae9ace19b82eed1de9557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a998523ef044009b799c6fa3fed05236e932462114ae9ace19b82eed1de9557"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee2dd2d36f56512a3482b041cf29edc91d1074799b337acb2694e085137616f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0be41e9ba17e441f861bee318f495afb6f54aadba3f9c88b333688d14849e07b"
    sha256 cellar: :any,                 x86_64_linux:  "cfd7c58d973f73419c703063c2882ef269ff5dc18a264caf9d03777a70d46c2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
