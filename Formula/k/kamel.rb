class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "64cbac848a8dc789062718ec8bc55e51fc95d176587c0c11719560d4d6d22304"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cb6f257d777d5a16c296a1d2f99b072f797930884a08984baf2f6174420329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0cb6f257d777d5a16c296a1d2f99b072f797930884a08984baf2f6174420329"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0cb6f257d777d5a16c296a1d2f99b072f797930884a08984baf2f6174420329"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f7272988866ceefaa6f9877bdd6cabdbdcc7b35a163c2deb4235fefd8cd3988"
    sha256 cellar: :any_skip_relocation, ventura:       "6f7272988866ceefaa6f9877bdd6cabdbdcc7b35a163c2deb4235fefd8cd3988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d45b6b754b21fdd7ad23ed720227b918d5fd74d2897323c800e7e7417c26f6"
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
    assert_match "Error: cannot get command client: invalid configuration", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output
  end
end
