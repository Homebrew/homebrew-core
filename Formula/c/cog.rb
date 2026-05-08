class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "c5a5e54e0c5582819a53658d716eca5954a2d6c52766b1c3c96019b84609cef0"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b9c9c40573ef25f63690ed2ff6c32742fee00c8c497008a2f5cb57df3455976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb959864120834d220313b392cf1c14d1f3b08bde16324e40dd4132339affee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2e7f2ad1b230389251e00a308bf505f5a3903c0e99e2a72e51402f5a02bc0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2644ae68dd30a3b35da80640954a37927e87a8f3ddf5210657c7b58fa9c59ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "744a32c531c9cc58bdb81a1a96bf1bb710d0a84ceb72a19d1cba2e9f3db48213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "589dbb85de44712f37047542d26440daa4fda030fa8541f1ba6b21bbdd50d7d8"
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
