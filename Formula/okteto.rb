class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.11.0.tar.gz"
  sha256 "c0e71ec96ecec1e5bb940716f1a9c3ac32da14d939c127900bdb57c250b4f328"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84b229fa11963a30df0d694bfd210521a9e7afab4696653407598b3d2a1cfb6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "570d82455bf4a21beb03f484e22cf21c1fe1c11f0451fa2e9bb70a84d31cf5c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "686a1acc4f63682ca65641e1fce21005f5da84e66942b5ae3cba581c86a34b45"
    sha256 cellar: :any_skip_relocation, ventura:        "2e5bb73815ccd1e25889bbbf5ef2503ce26eb3d3438075c1e0cc3a3d7eeb014c"
    sha256 cellar: :any_skip_relocation, monterey:       "737e142b6421a230ef4040ecefdb070e2da670c0d9b013a35ce1666722aa24a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "08ec68a353d6beabf014c97984ab5951bb19611741a078fb26ce77531f338556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208b9770c7032a602efe4e9dc7035601ea5aca624c5d06b84374cb64ccdbd923"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

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
