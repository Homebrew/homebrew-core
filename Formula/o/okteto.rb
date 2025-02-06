class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.4.0.tar.gz"
  sha256 "2b307e9c501b2052d4e17fb268630861242d65bbdf20047ff4a53e8a51589160"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5583f1df6b478347c20c808046c522453f4afb6b25fe315edb33084f23faa36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "818caae1ae4015885b0ab47dba761cdea86690940e06e571f7d34f36e7f46bc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e17b3a1a2c5b8b6a728a7cbc6c61489c6074a28f775b7ad0bb1b2f70e1e84061"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a2db9a0a24e9a7df38fa7ba3e666b8e9b7fc5fda760f94ea3fb51b053d4a82"
    sha256 cellar: :any_skip_relocation, ventura:       "be38c756dc9466962761c45dd99498f6f33cbfbc99f2d3f5a9bdff9671a7dd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9605beda953ff000f8df90353a72f48cb99702f618c5c5367c1b4f54342917bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
