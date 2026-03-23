class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "16bc1b7ae9277e109d4a8c3c607aa676ebd2ce07fd5fe44d4f4ac83fc12f9c20"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "860a3030deba778d991e3f7f32a82f8c85df8fc53e2f52861f3cf3ae5da6e85a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860a3030deba778d991e3f7f32a82f8c85df8fc53e2f52861f3cf3ae5da6e85a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860a3030deba778d991e3f7f32a82f8c85df8fc53e2f52861f3cf3ae5da6e85a"
    sha256 cellar: :any_skip_relocation, sonoma:        "73eabe3da7276ed59abe741cf3d4af043b84bf03ad34d28645bce04ea6e580a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6600bcd3fe110c6b453b36b5055ed23dced1125c25d4e20cdcb1333f8c089ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61ef4e5c1178f6bc95f5be201e8f56541ce2d0a3487d281107b2de069b557f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
