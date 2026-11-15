class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "a715b1ef3e8a4d4525155a4d30458d44b2aab2c9741fe89dea8bfd3640691bb5"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0948571ca33114301de28bd0603d09a35544b594b97cb497366a642fb9af209"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3be862544a9f634bdd3e90abd3772887ed1a7bdd96c7043e1058cb56822c1491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e851911df688f51760308e6c4e97b9696d1c5b8549c807f4fceba3df92188b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09845ff14a34a3c0334359d8aabbe3401a42f5461690037672a00b0d567df8f3"
    sha256 cellar: :any,                 x86_64_linux:      "ceaeab943d1040bd609a2c485e6f11bca23adde0c4f1d285a8e597654b87ea66"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
