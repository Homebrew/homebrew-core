class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.8.tar.gz"
  sha256 "92d34038f486395a973254070b7b42a63a176851b7afc8500be1cd2a22b3440e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91dddab14cb351870d2809ced79db3a85e7498dd2f8ab2c858511cee46d659d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3bb5a5edcf9d8019ed82dd6a592827ee617448692a40871ddfeb41e7107de4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db0a34da55850b1b46da776f1c48392f076551344a99bd718b730f77b8fbd289"
    sha256 cellar: :any_skip_relocation, ventura:        "1a7c5f29becde17f2908bc4905fa7b50b550ea1dbce2f92e9b8d244f52e8408f"
    sha256 cellar: :any_skip_relocation, monterey:       "5f8b8ce8638882108c48391ae1a6fa1e824b85ec9a73e4910029ac7789379cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2905df287401805dec39e969a3fba34712d3df36eeb93f75affe8d35663cfc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df628939eb826f2ec849467dad733bd5ea380b11f9e8fb25c6d50de5b509012a"
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
