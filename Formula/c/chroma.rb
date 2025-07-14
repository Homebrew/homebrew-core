class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "05eb3779cb0e42edd08146c76620f3c6c21a35c4c03a558884743b51e99a1a54"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4bffb63e9cf282af86bc809f0c3943c028e641449591ee11c4534093a3a5312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4bffb63e9cf282af86bc809f0c3943c028e641449591ee11c4534093a3a5312"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4bffb63e9cf282af86bc809f0c3943c028e641449591ee11c4534093a3a5312"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4544d04421f40b4bed519abd2d60e72cc5a3a1ba1477a2fdbf88ecb6cddac68"
    sha256 cellar: :any_skip_relocation, ventura:       "d4544d04421f40b4bed519abd2d60e72cc5a3a1ba1477a2fdbf88ecb6cddac68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d76a11eaa466f32ac4f4420136c9050603042d30b141bc14dba2e78ed2cf695"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
