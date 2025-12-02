class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "187dd7de0b57b2e92002471730ab26082bb52e4f15f53c1807e513c91d5f472b"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca3aa22dd67a3e11d3611dc25809bbb65654f99df47510b4f4e8ebdfb4dfeabd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca3aa22dd67a3e11d3611dc25809bbb65654f99df47510b4f4e8ebdfb4dfeabd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca3aa22dd67a3e11d3611dc25809bbb65654f99df47510b4f4e8ebdfb4dfeabd"
    sha256 cellar: :any_skip_relocation, sonoma:        "859d38993b5033660b26deba07d1917aae3afe72b14c92991ef7f19dc387a594"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f52bcc3d8a3063d5e2e75d5b65546b966d0ba97d26019018068d93ba17e86f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed251f4c4d62a5e51fbf6fc8e12973dce23970844056bc12f9ce08b5e8e03d4"
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
