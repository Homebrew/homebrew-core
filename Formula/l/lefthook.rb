class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "7d7400c1962616639b4ab33f2eebc5920c274fb69a2f4c848b17681a85bf571c"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "212b189f9a79eb3b8dc52ecf812cb52db7e12871a2b64eb8a0db3e1d5507c905"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1df5e3d8bc54fc82cb48f44aff2ddce6ad7f84dd3a97e910f9b3607e33bd5e95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2705a0785125a9c98a6dde98c9957a25f7ae4c45fe4958fe02fed45539cd1828"
    sha256 cellar: :any_skip_relocation, sonoma:         "394f91b23ae22c3fc84c23a0dda02aad4b5ed79b461374dd5cc49d6c5412de6b"
    sha256 cellar: :any_skip_relocation, ventura:        "b7069509073ea6e31fe2518c19834575e0eabd1240710def1e1923d65d2813f1"
    sha256 cellar: :any_skip_relocation, monterey:       "17f1a0b523b9e71241eddc01df8e0901c02289ca31318e2fe9b3d89b4db5634a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b790b9bd2a57c0f1091aeed594fccaa72dd2602f1889661d43a842cbf36070dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
