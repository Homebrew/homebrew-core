class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "703902e0b3fc35704173cc7fe0b8fd6ed144c1d251be1d32ec068c6c94edf55d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "521551bc8f0b00f06469bd34737c77e5f0c8586cc80182254c3be494f67cc409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "521551bc8f0b00f06469bd34737c77e5f0c8586cc80182254c3be494f67cc409"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "521551bc8f0b00f06469bd34737c77e5f0c8586cc80182254c3be494f67cc409"
    sha256 cellar: :any_skip_relocation, ventura:        "ea2db9988ef6c52b3555f2c08cff8ba0be217b6fb3ecb1815aeef9af24305b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "ea2db9988ef6c52b3555f2c08cff8ba0be217b6fb3ecb1815aeef9af24305b4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea2db9988ef6c52b3555f2c08cff8ba0be217b6fb3ecb1815aeef9af24305b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82df65e5906e23fd7cf001ee11ba9c1cb8edfe60cb8e73a33ecc78f4a8f9b9da"
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
