class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.23.0.tar.gz"
  sha256 "1ba41875b918db73c6a409ad8f552b85f72dfeea43ffb541b798322ff6b4152b"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4506e1cce44eb5d2497c7f8a7bfe519201160990fb8198d69592bb8d3328994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4506e1cce44eb5d2497c7f8a7bfe519201160990fb8198d69592bb8d3328994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4506e1cce44eb5d2497c7f8a7bfe519201160990fb8198d69592bb8d3328994"
    sha256 cellar: :any_skip_relocation, sonoma:        "957069cd0ea309c20e4d21c0f65d3987ab56cc3ea9df1f3713aa6e14c08727b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a13697cb67259be596fe688c0da6248076dd29539bb3a9c07c12e905cac7a8b9"
    sha256 cellar: :any,                 x86_64_linux:  "2de1dabf908d0a1be228908bb192448ad99969f90000eacb2295afcd19c784d4"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}/gopls version")
  end
end
