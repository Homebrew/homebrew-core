class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.0.tar.gz"
  sha256 "4df6927fee65b0003a0f4adeacdb73b1025d2808e9908450ecdb29c1df2e5fd4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2300f32096b45493be65577c4245b84a42f063691d29406905fd9fe22b4471d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0898d71e842d861d37c5c335876412257d0e2963a729f6ad3d46802e0b329654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c79b68116ed76f63fa7dc94db43841c342fca91a8d6f9d741386ec3d93807f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f9d3651f4c943c5fdb2c9cdbaff4ac0140fca0f1928b3b69bb0324d89b2efe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "776762b2aa23a12a6ab89f564038908a2966c59a2262575d5960b47b65f797cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12417fd2b5b6e4770d9ecb4dbee100822878bf7fd3fb7a873fda9ed4f0b4887a"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
