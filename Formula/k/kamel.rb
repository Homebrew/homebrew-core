class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=camel/camel-k/2.10.1/camel-k-sources-2.10.1.tar.gz"
  mirror "https://archive.apache.org/dist/camel/camel-k/2.10.1/camel-k-sources-2.10.1.tar.gz"
  sha256 "936fb5c9d5c1fd48f984cf9362dac4eb466543eef0a823917820402eebd2b941"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad888301c2107cc211a47578379178f4553228651e78f597d760535e164df599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e5a62206f5b40a367c886a0968f796f9a3d4ba2bb0cda26e978ac302f8d799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bc3bb8cdfa9434716722dd36f8f38487676e0dd45bde02926dac1a465f71c46"
    sha256 cellar: :any_skip_relocation, sonoma:        "5653c7fe121e593dd2fac37e083f64a7e8ff4ea17e3f56076a29eb323a485f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e48f773ce86c6ad327b9d98308c29b82be54be22dfdc573996a8662f69bbcda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eff60ba334459f7eb6e568c8c816a67d298b01ded4d6b9c85626b73df2e76a5"
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
