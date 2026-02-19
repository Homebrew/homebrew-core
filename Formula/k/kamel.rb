class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "35688ec92762fe699496eeda78abb7be5a8f6a1b15f3c1e0e55dfebf039be3f3"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb627b95421f4e70f8b9755294e6f6df367a8d603c7996a54f91d2bf6a9cf97b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ea3f22e4d4c30025aa2c1414cf9b1dc71bf816845adc8556b64dabf03b6e74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5cea32fdaa428e004e43460a998889711896236595c6297f7afe63b21a7e0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58377c1d306ddc59295de4ebc0638e7983341b2db1aab041acde48f4c75e650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "141e178c3efa3e97a11e1a9a0966416823a56a1d40a725c761ca95a6a37c38d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac5312075039bbd2e9972d719a3fb4918660b734cddd168aca20bfdf383a7c5"
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
