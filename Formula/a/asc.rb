class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.4.1.tar.gz"
  sha256 "b1d155b1cdc8cc0acc254203d8efcacd1bc57ab68b376e855b390bbf2dc5ee53"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9520c790607e1141389f5ab36df182a00e26f2f266f33b9c828d33271078d39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a3ca935c447e2fcae29e27c3d0a55a4beda303e26c1e3a18191988606bca3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee968efcf2c6db6efb70e49958954c9f959088283888695989c153ce9226d46e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cef5d4d1c3fcdef1f2f37de0fd82dc7a5336c1809850ad46a4e3696e5407a50f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c74ea6dbbe90261317ee3e01be28aa9f6ce650877f5d71492f0a126eac54f042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0431ba9d70e27a633003e44a152c315af1d08ab2898bb1db87f3d9ec744f90da"
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
