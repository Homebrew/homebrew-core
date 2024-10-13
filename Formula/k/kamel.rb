class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0535bb2c9c0c48f75bccd8a36c2bc866dd0b7959034ee18e473b08ff210ca9e4"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c9b39292bf67301b50525e2164b15dc97982c02e01c0e496f66630ec4244b3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c40989bf16afdb74e7466d995143cd654dd7491e75dea6a446efbcf61a0d89d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b02d4cdcf4e441ece927c5790ddf363ba23d0685c8d24f0158fdcf8bb6b3b33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2184e8fa2ba9590138339db6867a15323f2fd0faece3d21676da81053c7d47a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0ff32a5706a43a102fd7dfba4bd1e2454cd582bd79a806483045e289a223715"
    sha256 cellar: :any_skip_relocation, ventura:        "cdea98c5b849557f80f53e1b38ff9c38c158167b9985ead997dae82851275a46"
    sha256 cellar: :any_skip_relocation, monterey:       "371bc6dcd5e84c3a9331ad7f83652370227debae3c9f0e3d690916869209c327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad1923625c5a29ab872919b2613cab5d89e53d216cbfb36821d432ab1a517a4"
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
