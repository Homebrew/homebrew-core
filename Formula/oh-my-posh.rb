class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.2.0.tar.gz"
  sha256 "bf2d952cc4bb69f88c15aa05b41ff0b6a20a6dddfa3643720c16deeadc6ff1c2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65dd1dea9bde2df88e2f4547ef245ae9e9c8a2a0d794fbe414dcf6dba866b064"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23c55c4f1b0101f97d817943fc5c0bc4cb4b75a4e6464d61cab60de6b0ea6a7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00ce46828f0a9a376e28a3cbd7ad0620e6ad6e2a46945833f8022ccaaee605af"
    sha256 cellar: :any_skip_relocation, ventura:        "a3bd0971c1b9aade79ef99c4b510a15c762ce473c2eca7a56ac73005201f2e04"
    sha256 cellar: :any_skip_relocation, monterey:       "bed5c754321e59850d00b4ac8b01fe60c9a5a077499c5553b8a4edb7087fef2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "51d2775de85be620cfd621e01fb9d640aa7d0d4ce0059e7d257c316c0f6d9652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00307ee871f5d16bd9158964b233bacf9e79748fe22562e4e60865d784d31a6f"
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
