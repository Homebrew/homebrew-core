class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.30.1.tar.gz"
  sha256 "eeb7fc3159feb3c970a2d716d6c54eb1fca2600222e057586ee36b0835913ad9"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "329c5dc28cc3357b7cb607b67a9b4f46ae0610ce6e514ac932984fc81886d95f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eebde71635a4852c30ae538dcea48ae265ebd952fd04cf50547683982dc3b594"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7601ceb0fafa31a498d3301899cc3c867be052d30a7cfeaa05e3c2250709980"
    sha256 cellar: :any_skip_relocation, sonoma:         "75a006f6787c84f93f9ec417626d268a6410e9b17324f3a26b2d3f7eefc9517b"
    sha256 cellar: :any_skip_relocation, ventura:        "95507c9a81da2d5e27db13168187ad6b48b45cb4da3536bc13dbada0d43fc131"
    sha256 cellar: :any_skip_relocation, monterey:       "178aab839b7ff49a3076fa3592224dd60ed48b5823f5c57cde0a37cc46f1c7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e62188b91df878f947cd50e5426417274dc3d1cdca5a4231c3dfdef5a0edee"
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

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
