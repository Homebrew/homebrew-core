class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.20.0.tar.gz"
  sha256 "b92904b0bce510f6225cd152447099419b33edda77a66b6844190386383dfce6"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11decd8a920ec8e5277c27edfa4327b16b6ef7bdd8daacda0435a2a4be6db3c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca4b56a3c0edee9f5b4dae0901255d70353a063048f440104466fc966175627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19a44c104b72809d3dd3f54e87260dd85e1e5f3ddb9ddc1f40765c296012e0d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ec212e3c885693dc65fd725b9d0c12c80526b4a8ae6d80a01db5591792caec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "013859c2fce0f6ca22368ed47f2e68829874817f46c110b3f4f1ad8d83c50c2e"
    sha256 cellar: :any,                 x86_64_linux:  "dc4ebd6402a0faede2331ca062f25bd74a248e0a49bb853247711a304af088cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
