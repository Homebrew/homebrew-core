class Feishu2md < Formula
  desc "Convert feishu/larksuite documents to markdown"
  homepage "https://github.com/Wsine/feishu2md"
  url "https://github.com/Wsine/feishu2md/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "75f7af31916f5594c0cab11b83c27d3d76a2793c7a8c3f8b161946b515b626d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a4add21954328e5c8649ad16c7b522deef792ddb587757bcb595ea44cde1af0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c43560d1c51189e1b25f3d1c95a4985ee74615ed641bca383d4f3f3c67c791a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c43560d1c51189e1b25f3d1c95a4985ee74615ed641bca383d4f3f3c67c791a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c43560d1c51189e1b25f3d1c95a4985ee74615ed641bca383d4f3f3c67c791a"
    sha256 cellar: :any_skip_relocation, sonoma:         "db9e380e73abd9ce43b6f5a45a8c52c85ed7b6d72cc53d945eaaf9a528112306"
    sha256 cellar: :any_skip_relocation, ventura:        "f5f071e46875ce80111eec6c4fb4b2cff75d93d339046b98646de6a1712fe33c"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f071e46875ce80111eec6c4fb4b2cff75d93d339046b98646de6a1712fe33c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5f071e46875ce80111eec6c4fb4b2cff75d93d339046b98646de6a1712fe33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9995813ebd0136f20e81f30c9d73788cecb4344024f9f3498d99f997ff0c0948"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    output = shell_output("#{bin}/feishu2md config --appId testAppId --appSecret testSecret")
    assert_match "testAppId", output

    assert_match version.to_s, shell_output("#{bin}/feishu2md --version")
  end
end
