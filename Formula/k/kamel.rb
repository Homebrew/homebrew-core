class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=camel/camel-k/2.10.0/camel-k-sources-2.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/camel/camel-k/2.10.0/camel-k-sources-2.10.0.tar.gz"
  sha256 "c907969d59166525d7747504079442595472978514c9042cb146abbc9d3a82c2"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d184ad06985fc00bf34d6bcf342fc2768d4c19397a54d3ea99986c53cc155ce2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4bb000b40908827f88db41a0c829481b8796270a83786f5eccd4a55bb7d4563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fad1fa841d206b84695019f390397067b7ff516edd59bf6d009f592183216f65"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91a59f9c3cd7e9c11550d46b7bdfbaee41f0c3be994bbbfe5a544a9cf084903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd0e160f6b9b594925abd3076f62206de7d642212e5c46a3eaa3376b8108203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed031c47c8b5ab586276eca0ed6ae8fd9aab1c28bd4c444f0fb13840de9af80"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/camel-k/v#{version.major}/pkg/util/defaults.GitCommit=#{tap.user}-#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kamel"
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
    assert_match "Error: cannot get command client: invalid configuration", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output
  end
end
