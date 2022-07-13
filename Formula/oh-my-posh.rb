class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.16.0.tar.gz"
  sha256 "7b293085c05008e6be97281f20b700b1c905e1ac08b15504573291a2aa3e644b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b3e53456f9523d470d714a2f140bf16d00d51a188752a8fbad9202f9b9e328"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d7f15d03193c8786e26521db4cda02e05de4a5f71e2be23f77edc993c70e219"
    sha256 cellar: :any_skip_relocation, monterey:       "eb0d898d51ba49eb1c736778e6894309c6c42c6fe6d2f5d0d5ba66597c2735ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "78ce4b079faa50c75f5c5c047e353666b3b644a7acacd920af255589e33e0f58"
    sha256 cellar: :any_skip_relocation, catalina:       "bf0ecc339442884938470f674d40187e9c7b461c2a2ad007b1c776a0297601e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71be5b484e485f73883f1e0ae3bb7c50cd1cb2e6e77bf15471622dd59af0b9b9"
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
