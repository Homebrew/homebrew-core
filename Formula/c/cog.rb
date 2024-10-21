class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "59f7e0e738adfa27247809ec56088e3f007b2e0b1fd0dfe226b6b6aa1dfa3d35"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4453ef205245f25d2a0e91ef42fee1ef3fea7d113845517eceae1a3363a56a79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4453ef205245f25d2a0e91ef42fee1ef3fea7d113845517eceae1a3363a56a79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4453ef205245f25d2a0e91ef42fee1ef3fea7d113845517eceae1a3363a56a79"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bb208d7c78804bd1bf469c8760009ea74820bba8d10a444ce67cdfdaa9355c9"
    sha256 cellar: :any_skip_relocation, ventura:       "5bb208d7c78804bd1bf469c8760009ea74820bba8d10a444ce67cdfdaa9355c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e304fa631f105486f07dee748bc3d5e9b5a3a731d99048af9f7ef8fa1bbbbb"
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
