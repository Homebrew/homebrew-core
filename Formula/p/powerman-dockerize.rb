class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.25.2",
      revision: "311635aeeeac3869b2550879c856510698d05969"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6fdbc6037fed44ebded956c36a61b776f08436e3f8a0bd143c006ff126bcec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fdbc6037fed44ebded956c36a61b776f08436e3f8a0bd143c006ff126bcec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6fdbc6037fed44ebded956c36a61b776f08436e3f8a0bd143c006ff126bcec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c4d01f697d9b172c693f9805e03a24fe05e3a0da57970561654e12a6bfa854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6344495c51394121cde81a263cbed6afcae46b98098170f4c2dd034008941247"
    sha256 cellar: :any,                 x86_64_linux:  "bbad7943b1992243603d57cf4b015860c67458ba9949cab317e6e1dee4d6b236"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
