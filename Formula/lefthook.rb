class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c169ff8afd9f73936256e9b5063557debe9a7b015fd567b29818fb68ad8a6bb0"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f2ab96c2200225392fd574a2c4a06196a4f841fdf8d9e2b2516e70d0e1c709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9ed07ba0b06af28a884ef7e424202e377b718211200499e54e4d267d001c2f1"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc3edaef01f25a38f40bd17a44726d46b0ac2420b3a328ddae66ce7d5b03a6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b53c98f86ca5ec99a1a553a42b23ea72e0b9074ecc4f47edae3d6a08dcb108e"
    sha256 cellar: :any_skip_relocation, catalina:       "777f95d7eeb4a472f32c33d88e77c748ba85c0ae6cb1fc6e3754f173ec4ce803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "798a435460e7f5cfcb2387dfd7a10ff1dd2bb36e488d242119e7b9b162c22afd"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), *Dir.glob("cmd/lefthook/*.go")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
