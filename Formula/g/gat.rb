class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "424ad788c91081fe5db432f99d108802bb96ef5688b0ccb263cc4ca673efb155"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "c2c92380c5f273a0315482592ac9e7b55c2980ef23b52948adefe71a0e023628"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "823386ccdcd4c2a54c48dc644b2a79f493a8478913c9fe4ed4cde9c6a1ccae06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "823386ccdcd4c2a54c48dc644b2a79f493a8478913c9fe4ed4cde9c6a1ccae06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "823386ccdcd4c2a54c48dc644b2a79f493a8478913c9fe4ed4cde9c6a1ccae06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "94924e8da1b7b6c28581eeb9ca0972c238b80e600786c4c514376037bd85ba42"
    sha256 cellar: :any,                 x86_64_linux:      "74880c3798723a5f145365aad4712cc90e1a086d834df37c21603c6d84cbaaab"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/koki-develop/gat/cmd.version=v#{version}")
    generate_completions_from_executable(bin/"gat", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
