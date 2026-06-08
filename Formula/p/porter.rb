class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "8c9603671bfdcda82b19f0213855f0a66373cff7ba7994e22752233a7f95b1d7"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f09ff66e6988ead5e5a08e44463ae7b2b0ad2fbf47c83ca97bc44959a0cbdbf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "299b7617b835a08462e2bb45527a725795f7224def44d4c5bba8e5abefb905a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1cd437e10b25015be4d6b117a6ec72bc916c9d1b4864e7e38adad87f8b299fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3521d617fdc76dd58e4ec0210bd9b273053b856f41d0e306a7e39c5e406553fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9dd9a6d8c1eee295740c554e7823d2ef94602be32578f518127aaea4eb50b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85c23a8e11f460b3e6865f8a0e6f012a986a33268a9950909b4337be2bdc8da7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", shell_parameter_format: :cobra)
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_path_exists testpath/"porter.yaml"
  end
end
