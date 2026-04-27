class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.2.6.tar.gz"
  sha256 "4c28ee3b8133e8a234e7553233d751fedf2e3b8cdd3586433640f2336324c699"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5821d3ad5d4e5c37a96100116a4c3781a94ad2dda561ee891b20f5db0888b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38dd5277b911206777b76a430914dd588f1b731f4d2732235156971681639fac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b51109b31bef1542ba7c53e8abedde70af28b5b2711f6e35f4d9c1d01b73a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b883b778e8f1e1d7e6b607c48c706b53d506b34d079802174ae4dea00d5c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f1d52a6f70db3043c7504a247c1db906bf139eb2d548f5e7347c279576577f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "899be607003c871f31149401f766b79183dfe5b8e208d188195ecc4d71638167"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
