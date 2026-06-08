class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "30cd3e21e8f150081c79a2f656d43b46550a795ccc9cb7775bb7e68da686ee95"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c88c7c7ccf993601e3c5017b4431c7260e38f83b4d24e30cac927bd184eb495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c88c7c7ccf993601e3c5017b4431c7260e38f83b4d24e30cac927bd184eb495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c88c7c7ccf993601e3c5017b4431c7260e38f83b4d24e30cac927bd184eb495"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca3bfa896f392fc2d30992b191d9b8ed511e81707c778f8ae15dda052a0d73f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa27e252ea0679f043ad9352007d52f40a90b84dd852062ede0afb99c76c3b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310e645f5844956602bcc9b5339e09dd2387a5a373b4b73aa49b82b1991477c7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mbrt/gmailctl/cmd/gmailctl/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", shell_parameter_format: :cobra)
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
