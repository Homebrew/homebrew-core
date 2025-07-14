class Pulumictl < Formula
  desc "Swiss army knife for Pulumi development"
  homepage "https://github.com/pulumi/pulumictl"
  url "https://github.com/pulumi/pulumictl/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "36af696d99adfa8ca5941780ad12f13116178f252fe47e24a70be0a2f771b0d0"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumictl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f84623a5d8e33cde3da4a009de0aa603d0c0418e411d04a33f6bee024b3465d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f84623a5d8e33cde3da4a009de0aa603d0c0418e411d04a33f6bee024b3465d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f84623a5d8e33cde3da4a009de0aa603d0c0418e411d04a33f6bee024b3465d"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d43a6077e2debce71dbd7dfcc917768d0d51599f5c528c906070931280fb64"
    sha256 cellar: :any_skip_relocation, ventura:       "85d43a6077e2debce71dbd7dfcc917768d0d51599f5c528c906070931280fb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa43bcca9b9a843c80b09f04f0ab34391ca358f036c5649f87e15ce7ff760b8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pulumi/pulumictl/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pulumictl"

    generate_completions_from_executable(bin/"pulumictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulumictl version")

    output = shell_output("#{bin}/pulumictl convert-version --language generic --version v1.2.3")
    assert_equal "1.2.3", output.strip

    output = shell_output("#{bin}/pulumictl create homebrew-bump v1.0.0 test-repo --org test-org 2>&1", 1)
    assert_match "Error: unable to create dispatch event", output.strip
  end
end
