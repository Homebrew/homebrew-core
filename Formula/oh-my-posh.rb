class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.19.1.tar.gz"
  sha256 "fdd7e4aa14c5b47ce797c4b63829f09fb7b679d42c609445327280cd2488b0c6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e197216c400cc5f31128775694438bb46d23f4ca68bf472c775660522adc2caa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc0aa1bdabd18d045efb10a04a99c9b5ae8a067ffa22a9adb74593e2a011088"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b42dc3289ae649674379b9b309caa1593bffd8380cd9a35f25beb97e812dcb1a"
    sha256 cellar: :any_skip_relocation, ventura:        "1ebee8fc50ca2fe951252c2d2a3171bc9a7d9239322d8fa3a0e23acddacdbedb"
    sha256 cellar: :any_skip_relocation, monterey:       "50af4ca56a4e41fa1708c5dd31a4e7cd8d4e23f433133b292bceb796e6bbb2e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a08fe3765efc9ad2a34136772dc68b061e68b93909f99cb10cb422353d4512b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6753cdc1305ea9b876cc1cf11ce81ce00e291b948a259ae8b604ea4304abc08a"
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
