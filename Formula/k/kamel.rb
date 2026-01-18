class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "6a1f3639706546e075730da65f9424522ec5f211f58f9227d86f3ae81c590ccc"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99a4f6abd5fad338f5e4eaf257f3b9ab33537e79058fa83c5e8bcd3586db37e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fcb3f651a84510efca65284c620f0ff3874b7c96be24023354b6e2da93a490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345d90a1847ae8c3316490f87c248f34b34cb0d61953977d44582355d8e3bbd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebee5a4097064b465e2c1cbe16e5c86676cdc099f9fce3684cf47507a3ab0983"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3fd3e01f1a8061872ce3d6a017acdbbb7cfb0d85b073dbe592b3af353dedd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93bdf0dac9dd18600e61414b2af96f6667e65f85524973b083babff2b8ad1481"
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
