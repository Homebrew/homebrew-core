class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "119eb70ee9148a3165ec0082f3d6da44baff68edd770d89b7c7f030bf03ddf1c"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f97d54cae48c5ef52af293679103fb6f3a68f2955fa1d0d5fbf46705327d03ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9fb9ada0461734d4aede5b96ca62d0e7c771c94805b837ac8c70f1afd57e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566cde73fd4fa59fda8c24f92f2879128c3a1169562d8510e0d23b7bee018e93"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2753d95361970ab37fe85419ebd58798e8a6e41b6af7ddac8ccaeb4cbc0f4b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "842f87f15afb66a7720adfa74f7b4a644fdf9170a7263d11b04d2baa2a03fb13"
    sha256 cellar: :any,                 x86_64_linux:  "f783c780ad177816d64d4d12103f7fa9b5e7c9ba92d2fdeb8f57e2a8252db2f8"
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
