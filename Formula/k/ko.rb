class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "76275e4262faf2aab10507b969a50728dbc3f48511e61d138c834243f60452b1"
  license "Apache-2.0"
  head "https://github.com/ko-build/ko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46c2cdc43550cd514557243e7caba53dd8365d8c55031ef1974454f18b71c57c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c2cdc43550cd514557243e7caba53dd8365d8c55031ef1974454f18b71c57c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c2cdc43550cd514557243e7caba53dd8365d8c55031ef1974454f18b71c57c"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e6c3feeb606f461a7c1e07e6eecf15ebf6cd63bab649156bca18924f69346f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5790130d4f3ae7e28a03762ff50ad252b4a03ee6d7acf5712b19f8f021fb30b"
    sha256 cellar: :any,                 x86_64_linux:  "2366d57b384117b2575ccaabef01f1fab6c49b36f682190750b524796ff9046c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
