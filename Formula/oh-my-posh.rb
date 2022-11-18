class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.14.1.tar.gz"
  sha256 "864047a58290ae6b578e51bf163b1a79c59fe3c99dba1118b993f7f9545d53d4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6cec4c462a366f516f9db4dee7257fc6056bbd498efa2eec483d0df39af6795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc1dc9c94d044a3181422830196a6e81a47e3ca3a0a1acc9901e872765abcd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b036255b831bb04598118cee83b1f86f853d2097be4f7c680f7a705971c60db"
    sha256 cellar: :any_skip_relocation, ventura:        "9e7d2592a163e803e65b882f9b359fa996eed379ec0a3603043fb45bb5364d86"
    sha256 cellar: :any_skip_relocation, monterey:       "1808b0c8597ff0fa86f285c54c7ff4db99316804de0f69ac3c356d733eab9449"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e166845b2335cb6bda94b72960b488758b8d51218f682e56fc20a864be97fca"
    sha256 cellar: :any_skip_relocation, catalina:       "08dda4a14f0637fd01a64d0f19418e159b1fe9e089ae4ac6f7a37f369e1023b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a3aac738062a506c45b4f6b2c6c951e0accbd999697bff500aa8d8705f06674"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
