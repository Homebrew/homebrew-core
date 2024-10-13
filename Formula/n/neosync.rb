class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.77.tar.gz"
  sha256 "7c3d163e36c1c00c093f48c4b30db66052b68fc54ca202714023984b6fdc1d02"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7439936fe1364c3fa199cd30dbf48e79b70b41a6c3d9744455ee040f377f2828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7439936fe1364c3fa199cd30dbf48e79b70b41a6c3d9744455ee040f377f2828"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7439936fe1364c3fa199cd30dbf48e79b70b41a6c3d9744455ee040f377f2828"
    sha256 cellar: :any_skip_relocation, sonoma:        "27747deaf50e0515ebf090928a786380c99ba374f59f8a433288314cb92b19c7"
    sha256 cellar: :any_skip_relocation, ventura:       "27747deaf50e0515ebf090928a786380c99ba374f59f8a433288314cb92b19c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6226722bf8aa4accdd151809e24f435b3d9e52bf2bc1f1e8e7b269df071e826"
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
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
