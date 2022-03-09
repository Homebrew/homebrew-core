class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.35.0.tar.gz"
  sha256 "8d9e919cbe79d7d12f0c0115331e2b60bcc210cc5808cc2ca85605b372c39696"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3e8b90eeaa87026bfc0b88856f2216ef6d8fc1c4ce76aaaa0067df3518e54e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97c52ae50a1fd47b23903e56ac6b9f1a93c04ccd9f61a944e0455d66a5a879c7"
    sha256 cellar: :any_skip_relocation, monterey:       "609ab28940efd0b42d67502b4a3771b1b0fbe1d1782fb5069d078e5868e33567"
    sha256 cellar: :any_skip_relocation, big_sur:        "74aba2a5250350b523b1b865e7e465909d5c6262f4fb7448a897b5c55a359084"
    sha256 cellar: :any_skip_relocation, catalina:       "102c5b052197c45f5e4f82188b584313a5ee5ca389cd83f32034ed43fa17049f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f8ee7c4c8bbfc8e9631bad332517f9c0eb52641d7616673bd029328b1675980"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
