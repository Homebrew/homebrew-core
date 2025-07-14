class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "f9d95d98103a2c72ff4d3eacbb419407ad2624e8205b7f45de375b17ad7f8d27"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb52067991189975a07e77ae32264452c9569304860c454f2a3718f91e2cea58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb52067991189975a07e77ae32264452c9569304860c454f2a3718f91e2cea58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb52067991189975a07e77ae32264452c9569304860c454f2a3718f91e2cea58"
    sha256 cellar: :any_skip_relocation, sonoma:        "df374d568e2b22e033e11a699ab461586b32d70d2e3ad9c5e239c02491f3769f"
    sha256 cellar: :any_skip_relocation, ventura:       "df374d568e2b22e033e11a699ab461586b32d70d2e3ad9c5e239c02491f3769f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d30dea036cd3771598bbab66b0ac58bc2c4f898d2e255de11e00d7eb42d5b24"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", "completion")
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
