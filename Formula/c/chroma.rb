class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "45deb53e12a92cea43e797ed3d1edde0bf6ca7492d454126506e35e8822863a1"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e64d4f537e4a3bc1f1480bf900cf6464e09e9416ecd8420812db6294bb5454c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e64d4f537e4a3bc1f1480bf900cf6464e09e9416ecd8420812db6294bb5454c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64d4f537e4a3bc1f1480bf900cf6464e09e9416ecd8420812db6294bb5454c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "50de8d019405374ff7b9f26f2ebaa95d5a2c9a7142e44f5a5c082ebb6c53f51f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32824b5f181ff0f59447cd5990d93c7420ac53f88ed659e1d457a33cb0dbd34e"
    sha256 cellar: :any,                 x86_64_linux:  "7754593df107011aa33c6c45e4e7dda5ecd5b384d7c02de382a11b58618fba93"
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
