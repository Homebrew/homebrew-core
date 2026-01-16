class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "80c69d5bbfd80350fdf2022395877c013d14397f099c729b9f44b94d62d127ea"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aa5bd26c3096a0771e74d85c3d5e9a13334309c852bdfc8d75e1dbd7f991a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa5bd26c3096a0771e74d85c3d5e9a13334309c852bdfc8d75e1dbd7f991a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa5bd26c3096a0771e74d85c3d5e9a13334309c852bdfc8d75e1dbd7f991a6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d52f8dfa8c9d1c452e7a39ae44e26c4d6c71c25b4ae6ef3fa73d4236d87af6ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d06bb24b1ea38509e0edb9ae12e3d95b4007499e92008ca00090cff4f632eb19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38293817ed0c1b51a94b5f5aaae229cfc24b1362157926de6551ad8af46b3576"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
