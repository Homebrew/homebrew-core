class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "78b6a312adcbadadf221d5ffa566545b0b30e74dee79f7e2eddcd36abde24923"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd52a28167315b28b632f59b792a19815ebc39af57d5e70a43de7f74351d52b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd52a28167315b28b632f59b792a19815ebc39af57d5e70a43de7f74351d52b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd52a28167315b28b632f59b792a19815ebc39af57d5e70a43de7f74351d52b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7012197df2ee3bfb2656435dc61b3a315c2660e608f86a1a1c4f045a34792497"
    sha256 cellar: :any_skip_relocation, ventura:       "7012197df2ee3bfb2656435dc61b3a315c2660e608f86a1a1c4f045a34792497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67f853f7c93a1c8c71cb74a0b5f6430b0b65a0b6b6f21d8ebd9a5229ea9044b"
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
