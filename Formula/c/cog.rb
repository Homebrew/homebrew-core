class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.26.tar.gz"
  sha256 "46ae16f928c8591622c8c61c44bce029a9a5202b5d65609ce505686d935f4e08"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1390df0181cb0ef8b0242b1dcfaac6d4664f048cbab4ed152958da80fddac13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1390df0181cb0ef8b0242b1dcfaac6d4664f048cbab4ed152958da80fddac13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1390df0181cb0ef8b0242b1dcfaac6d4664f048cbab4ed152958da80fddac13"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9efc2498a44d8a592ee387cd61dba64a61921bbee0c35f80515007376509cf1"
    sha256 cellar: :any_skip_relocation, ventura:       "c9efc2498a44d8a592ee387cd61dba64a61921bbee0c35f80515007376509cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd585b656aba69ff06f0747eecd4cbe9967627ffc20de4d0838cd0c53d008ea5"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def install
    python3 = "python3.12"

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
