class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.13.tar.gz"
  sha256 "7f5dbf8a22aced80ed36d712744d295d696ff3894ad152680089196d2dca93c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "851f7ff589702223822ee0315124e04fe601d003af0f63f7b7316f2ef6f4d607"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b2b6fa5cfc1f9849a546cb3ab155b5484dd677145286bf113e893ab4fb1faa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc6a48304e59dd19d73a5dc7df5ce3b0c4e90450fcf39f55c199bc7bec371925"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc7d069090f8e1ed7370fcdf0069d382afbe3d74bf66b05989aa12865dcb8689"
    sha256 cellar: :any_skip_relocation, ventura:        "3df70e1e8d21c568616a43333e345ac4913165403e8bd789b258de800779895f"
    sha256 cellar: :any_skip_relocation, monterey:       "f0b9685e5f94ff5edf40ec32a377be839da6d3afc4bf724a7497355caf5c8547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "512113c26f85c3424d6992c3ea3ee0ba477f7ab2d490b32756ea3413d5c52e87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
