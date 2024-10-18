class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "993ad317c934ca9af51b10cf2417300f8bb75571bc0813cf93d830db23674a70"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ca111c8f60f8dbbfd039af411419276aecf12eab07125eba8bf3e22a000f6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ca111c8f60f8dbbfd039af411419276aecf12eab07125eba8bf3e22a000f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4ca111c8f60f8dbbfd039af411419276aecf12eab07125eba8bf3e22a000f6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff08a50e7d8ab9d2ee5803d8365afc5382436bed4b46856cf8984aeda94c733d"
    sha256 cellar: :any_skip_relocation, ventura:       "ff08a50e7d8ab9d2ee5803d8365afc5382436bed4b46856cf8984aeda94c733d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8be903aa8536ce35c75e0843f8ec89f41d68a92be8aeddeaae9d243637474945"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
