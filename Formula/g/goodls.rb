class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://github.com/tanaikech/goodls/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "5acda68a159e8bc7d8dfe164a2bb44a8868240db9394b6c5eff93233260a4b8b"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b0351feee58be0f96c55c2a71854e2deda7707b69685200fbe2132068389e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0351feee58be0f96c55c2a71854e2deda7707b69685200fbe2132068389e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b0351feee58be0f96c55c2a71854e2deda7707b69685200fbe2132068389e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "a03ad46f4c37342d4d60f88208b8e76f67c73ccbe9f34667ea9a09f5ca7750ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5498aa2f4261bfc45b227b230dba46863e5abcf03ee6234490e9e931e686553c"
    sha256 cellar: :any,                 x86_64_linux:  "f5dc144914d27a638b272bd967342f9fa6cd0bce2861875fbf557035bb72481a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goodls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goodls --version")

    output = shell_output("#{bin}/goodls -u https://drive.google.com/file/d/1dummyURL 2>&1", 1)
    assert_match "URL is wrong", output
  end
end
