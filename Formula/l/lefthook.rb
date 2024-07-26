class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "f000657f4e9d0ac3da23a75edff2432b541fc7b4f0fa3442c3753524fed747f8"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88bcc5a3de5183364aebc0ce7e5ed16e40ecbe683b2336cb1786b71ef5356a85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6259c35f4646eabf41874eb9d6b594419d82a0a6ad15ff424cbd301458033fbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a536faebd394429e7c35f6af8d74806b706520ee55d07caeea865d262fbfe7e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e75c0154a5109ad0b7f65403fe3bfa46427e723a6b6a54d8cd340be3fd90517"
    sha256 cellar: :any_skip_relocation, ventura:        "bd91e1d8dcd164c06b0c6fddc93ac63a930112fa22fbd4442bace9f948fefec7"
    sha256 cellar: :any_skip_relocation, monterey:       "a12647c58d27ebe6e445bfd137672789d2e0c69407f1858ee62408112dc3d58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0dbd07e06e5bcca0bb164101b3d111e36c562d7b736fa7560d5858ad8a1983"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
