class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a428dfc940fc89c9469d7a57d200f8b50dedc098666e50c5a9a90c4fada11c18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e39ce127b92b441d53775d3b565f2cd26ec92b2aa6372b2b33cf3d8d9a941074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39ce127b92b441d53775d3b565f2cd26ec92b2aa6372b2b33cf3d8d9a941074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e39ce127b92b441d53775d3b565f2cd26ec92b2aa6372b2b33cf3d8d9a941074"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1bd9feb56d85ea4c760dd55d76e0c78983324ce376549da4f1f08f38b20b743"
    sha256 cellar: :any_skip_relocation, ventura:       "f1bd9feb56d85ea4c760dd55d76e0c78983324ce376549da4f1f08f38b20b743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770a6306619e38c1ef0c13cf707d36ec7ee9a8b98e709f1bfe845f82f4b8ae77"
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
