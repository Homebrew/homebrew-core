class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "c0ff6ca2661c58a5134bcb6518e23205873ba0b91232ea854333abb953d268fb"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e65f0af79120cda9af48fa1bc512d51e311aae1a27d41037c4f7f4ea8eef3bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17176007720d6f98a8c34a4fab42aad4bb43fdfd2f87d469e7139834c78733f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6089b2d54dd76efc8a15bfd020a1e9cc0bc3d0b41a015cb2fbf9002c66548eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc4eb8743d995b2754268d7cdcc765c0967eb790cb8b7d0e8d00e9effa9145ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d9a77f70d00ff2d3aef8f95d0ab268f07487df60d0b2eed98d636e83e03f081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97e835c7ae028f408631d3964e4bc3c22f1007ea03c7d9c507e3fed555cebaef"
  end

  depends_on "go" => :build
  depends_on "python@3.14" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  def python3
    "python3.14"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
