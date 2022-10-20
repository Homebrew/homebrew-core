class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.18.0.tar.gz"
  sha256 "f4635db90af2241bfd37e17ac1a72567b92d18a396598da2099a908b3d88c590"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6187cc49a089a96a15fda4f1899b302dec13bf256febf4015fd5484a94a7bbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "820a6cb5f7f706ab12717e23586d2eb788ca8d5a5140362092945d2a8d188620"
    sha256 cellar: :any_skip_relocation, monterey:       "cf517bf55f67746b5a2a5094abc5e5d0dff66069aec220cb89e792af08ea0a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6158072faf7d59114696e5a7c23ec1ed0bfd7175ff970fc0f0b6a6e0933f0fdf"
    sha256 cellar: :any_skip_relocation, catalina:       "64d1ccfdf5e9d3026277221274b5943225de6d65520a06bcf0eda6f13674fa9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc21b2de77e60c7193eae1dbb1e9d317b766e043dd4bb504c05c259970192467"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
