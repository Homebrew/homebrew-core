class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "5eaef2de621e1502f0c449cc52b48d4de4a7373353f5008d0334172dc356b336"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0800de5460f352f9d50f4a134635a3296ba90c037e791ee1dd9f4189a9628c5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0800de5460f352f9d50f4a134635a3296ba90c037e791ee1dd9f4189a9628c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0800de5460f352f9d50f4a134635a3296ba90c037e791ee1dd9f4189a9628c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "84bbf15521ced65293af267efc8dde889080afa6cd249609c72b87432830cc8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "384bad1522349469ae127db07d8c0732d1d0c8f8ec9edd6ccdb3fb624fc4e393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75bfa2a6555d4958893187e1fa8029cfbca1a324a3046e535ac6de0ebe9daa02"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", shell_parameter_format: :cobra)
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
