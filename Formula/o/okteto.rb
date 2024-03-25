class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.25.4.tar.gz"
  sha256 "12ac67b40a89dc5a9969579209b4095605d9f39f755002a14177c768720d284d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8834c24cd0b28fa930b7cf057f517f790630944329edffab079af3f93b129894"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e63ec93c38d5477819cddc1e79d42acd6548a54caaebba3fa4ed94238c34ce9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d1dab70fdef9cab8d972d247a229f1688a5f8ba5c9a5e27d792f76264e66c62"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6f4236a6962938d7f1ec67ad32c269b5c37fd37d8e0aa3423f479fbff7504b4"
    sha256 cellar: :any_skip_relocation, ventura:        "1d693f13a38d0ed34eefd13940d7e83c81afd288b9dd4841d208487690150dfb"
    sha256 cellar: :any_skip_relocation, monterey:       "755fc330cbe86dfdc44da7abaafebd8ad1387119eee003d897aa30e68fe7aaec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "339d64e154a0e2c724fa78f3b7ff06adbe27547c1892586e4113fc4ae2fae241"
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
