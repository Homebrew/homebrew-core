class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "31643789f958e4d1f552d9e72efef64cc500b5b3408b2ad546d862ba048655a5"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95e2e0a3fbb7e5b3ca9b64192b5d37063c8cf43101c0c71b1d27ac8ebbeaeb33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95e2e0a3fbb7e5b3ca9b64192b5d37063c8cf43101c0c71b1d27ac8ebbeaeb33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95e2e0a3fbb7e5b3ca9b64192b5d37063c8cf43101c0c71b1d27ac8ebbeaeb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfdeb6e012ea5b9fccf99bb3d73fe9f70e8633b84f2236e7bf9dc784f5234274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc8255f45f2a5f660f0f648bf883b779fe90e9a322e7ae08b946d52b54a7c832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d18394999cc53b141589dc5f6c1504d9b86d158a58a8315bebe6a3dda2cf1f3c"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
