class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.13.1.tar.gz"
  sha256 "072ecc76fa9abbe97020410a8d87d1def24c15cb15df4c1e89a4240495e43a81"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7632e3f89866b87f065bf87c73bc231af9b1dabf62f842e215f74e151d8375"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b91d4c0445cebeca9f8caddbb9fa50761189aad43795e85e268ff99fa246975"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0233b1cb730b4843f0307e550fce18a553fd1ab247aeef0ad5eff1cdd04d54d8"
    sha256 cellar: :any_skip_relocation, monterey:       "a72b55dc8dee05a0ed9041c1cf40346bac7fe51234eb4e1002a3d3757b8038e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a404d2b1ea1b6524c0bb5eacc483e2035c63036c701b94dfca97a7d31f8bd1eb"
    sha256 cellar: :any_skip_relocation, catalina:       "bc9e207a9a0903022844b0ffc15943bbb5b68c2095130d9c2c5a21d096497acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257d7c3bafaddad3a4fc5e95498b3a66079bbf8c9015c6d4716ca4ea843d96cf"
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
