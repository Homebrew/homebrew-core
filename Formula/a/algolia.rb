class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "0234fda05d6351fec58b8749ba618054db9d783a202c142c246eef12b35d200e"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "182ac16523f959b5c791ce8c6e7bac7f48d7b01284f2d5aaf88e98bcf864ae2d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "182ac16523f959b5c791ce8c6e7bac7f48d7b01284f2d5aaf88e98bcf864ae2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "182ac16523f959b5c791ce8c6e7bac7f48d7b01284f2d5aaf88e98bcf864ae2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "182ac16523f959b5c791ce8c6e7bac7f48d7b01284f2d5aaf88e98bcf864ae2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c7c6b9c194e326b6b7c71c5d3987594552acede6a1bf98e44881ebebaeaa2aa"
    sha256 cellar: :any,                 x86_64_linux:      "4b62873f444bf8f833bc4b174826d130fc8be7d81e98273a1fd46d1979140618"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
