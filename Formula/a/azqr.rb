class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.4.5",
      revision: "669aca130d6232a413934b1cfdd4e67c2dc7efcf"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362c76de73f7c8d6fee4e64af20f45157287dcca2b291a09aebbdbb99afb69fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362c76de73f7c8d6fee4e64af20f45157287dcca2b291a09aebbdbb99afb69fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "362c76de73f7c8d6fee4e64af20f45157287dcca2b291a09aebbdbb99afb69fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "69e89765513c81e45efe0d5c3a39c77eb1986c507357852f65f0d4c78d347eb0"
    sha256 cellar: :any_skip_relocation, ventura:       "69e89765513c81e45efe0d5c3a39c77eb1986c507357852f65f0d4c78d347eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb2307c7ede47380de31dfee250f1b587f1bc3c0fab35f5ace7b3d4e58feac1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/Azure/azqr/cmd/azqr.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
