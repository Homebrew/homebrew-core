class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.0.0.tar.gz"
  sha256 "0e04b8e94aab95460e03dda7304a52669bdca13aef82b68209a369e8c06704af"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5d5e7104eb171822d4d76056ffa77f884f14b246fe2f5759041a33b941ee037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c0f124eb885cfc8724df99db06dd143bdc8e66e489aad4a6e3f23bfabdf4dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7402a85a9f104e6c14ce5328106f772bfec241b4466750478674b1a401c30840"
    sha256 cellar: :any_skip_relocation, sonoma:        "f079b7d67caf6dcf3232cec0d1bd0d99e466bfe466875da3dd32cdbbd7643c9e"
    sha256 cellar: :any_skip_relocation, ventura:       "6a52c3de2563b3dbe0488638d12264fbc061c07b2259921c4c0634bdc9454ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114b6f683464675d041447c5713ed56e74926a84690359359c3e83f8e753d4ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
