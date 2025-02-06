class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "b504fb87f54d315d4419a72e2c96ccd094316088da87b94c22fc0a705c45c3a8"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3438315113fac138634e71e252ab5aa278e92082413bf8bed00b0d6bd4fe5ae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3438315113fac138634e71e252ab5aa278e92082413bf8bed00b0d6bd4fe5ae2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3438315113fac138634e71e252ab5aa278e92082413bf8bed00b0d6bd4fe5ae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "149fd549780e6949ee1d6093c2c6c7805c74e2a593a6b53716f4fc2a552a761a"
    sha256 cellar: :any_skip_relocation, ventura:       "149fd549780e6949ee1d6093c2c6c7805c74e2a593a6b53716f4fc2a552a761a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "333be0283608f653ad09e7adb9cd763af247574cde4784fce7c937a5f1a19dce"
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
