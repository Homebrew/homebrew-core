class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "df174bfcd08fc89d4b606334559827865ab1ae7f5877b2f001963832ed083b20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "416e3499083bb78aa06a80d8996f11110aea98e1adb5360a2ba81d26af85be3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "336cb22a0909c392c3a4cbb31f29ceabc181dffe87965db1c8678a7818d571b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeadabd4c93dbf02245a50cfc0b36550a8a01390d0c26c181306200ba37014c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07876a166cbbd7fbbe9ae40e8ace7d26b833588340dd37b59df4cbc4b4c7bd3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "04b67dcab6d8bf77a0b1152457957db7a9334c68501e1146fa0d0e74fcb85cf2"
    sha256 cellar: :any_skip_relocation, ventura:        "d36d94cab032269039058043c8a32982ce4ef62286dba453762c1b3bb2a7dd19"
    sha256 cellar: :any_skip_relocation, monterey:       "48e5871b03bbe322e36cc9d8dcc900a4dee201bc80c2c06d6f7a1b6211f9a30b"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaa4b30b2473e5f7f2730f23034f8bb3710560f1bb8700f5e8ccc55f17b9dfbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4d20c05b6670efa6467cbf3f8f231029ae0f870c1e44eee991363d4eab6bdb1"
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
