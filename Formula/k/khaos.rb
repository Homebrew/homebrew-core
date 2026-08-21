class Khaos < Formula
  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://github.com/aleksandarskrbic/khaos/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3d20d75c1977eb9c490f10cbe09cfcbfdfc673479f499877fd7b872555c0c0c1"
  license "Apache-2.0"
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "39b134bb09ec747018cff4540ddbc8f810f03b7d80e5fd2f372d7e727c6e15c2"
    sha256 cellar: :any, arm64_sequoia: "fe9521b05fb7c934fe62a6801fd1ea23ce7958a6cd266149ba769937fba18c78"
    sha256 cellar: :any, arm64_sonoma:  "3c3f2277e9f65c8ee05e147e58dda116491518fdde139c581463aacfc6a36e43"
    sha256 cellar: :any, sonoma:        "afbcf44f2411c99415555f8b26edda96a5cb55d82af6da91888f35b9d367cb8a"
    sha256 cellar: :any, arm64_linux:   "eefe195c999f0be33e69642f04049954e6b2cfc51de6cba82ff4104ea48a45dc"
    sha256 cellar: :any, x86_64_linux:  "5d8e5c89312449978b54cbb2543285e54cd7124a0043a90666da21cbac9585be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/khaos"
    generate_completions_from_executable(bin/"khaos", "completion")
  end

  test do
    assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
    assert_match version.to_s, shell_output("#{bin}/khaos --version")
  end
end
