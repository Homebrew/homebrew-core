class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.23.0",
      revision: "70a40e0c2787e60ce70662c32a8e5c4c91fa79bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f965d80fdc381a9376899e804f28ec6aa64a668376e79e5fddeaffd4c384f237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f965d80fdc381a9376899e804f28ec6aa64a668376e79e5fddeaffd4c384f237"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f965d80fdc381a9376899e804f28ec6aa64a668376e79e5fddeaffd4c384f237"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fcae88f9e8d59cdb081ff181cf4fae45d076b217015dd3635350bcf16ada09f"
    sha256 cellar: :any_skip_relocation, ventura:       "1fcae88f9e8d59cdb081ff181cf4fae45d076b217015dd3635350bcf16ada09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f4ee377d76ec7b6a72e724f5c7c412cff5a49a9b371c83a7bee4ec28c759485"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
