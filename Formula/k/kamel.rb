class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "9f35998ce81f41a78b5e7bcea19a641b91eee8c562b3d985911689c0c69acf02"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bc41672d30de63febb82af897d83bf4ada577e28f455ef0404f26013bd66bc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be1f75b49a51021890145b4c03ed2447504210e63f7648a8d228269e3e3c5728"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a42d1314f37b9bbb8c9a01fd2da3df7c36ab4902beb2173d0a2d9d3481987b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fac9e6da3cce2f0b3faceca6e8ff53410b135e25eb2758eb9090d53ffd2a0fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "0a45dc018e478e87cdb60d25b4db4b7aef20c1c8ca74efcc5cc017ac6efb552e"
    sha256 cellar: :any_skip_relocation, monterey:       "43d88d7cfd2e5fd2c691795859e08e8f747eb12ad58e021e471850c94303cf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b24338b1d3e12bb9f39beb8f468adadb510ba812c9144dea798e208245232073"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/camel-k/v2/pkg/util/defaults.GitCommit=#{tap.user}-#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kamel"

    generate_completions_from_executable(bin/"kamel", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    help_output = shell_output("echo $(#{bin}/kamel help 2>&1)")
    assert_match "kamel [command] --help", help_output.chomp

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match version.to_s, version_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
