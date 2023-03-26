class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.19.3.tar.gz"
  sha256 "44a3a2615dcbeba3e1d84b597549f0d013e7c45c87fbac9ef2d93289790f30c2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6abb6a64364295720b9b7061df845cd5cf843bbc3b3c20fce6c4a042f983335"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd390134e22645939884b28dac25d031a12daac6ddb47d72456e97d6a2e73ada"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86c51548cf5ff536b6381b3a42e17efbefb624a32c5e3fa1636d950bf14c01c7"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8d45928fb6472a5d285836cad54e639cf7fd71fc99d849ec454a0e391a4c62"
    sha256 cellar: :any_skip_relocation, monterey:       "f5dfb07f2f33016bd09d87dff0a7e9c25a22deeb0fac11f17a553918491de90e"
    sha256 cellar: :any_skip_relocation, big_sur:        "defe8caf60cdf729e22006ecda4984c08ccaa28f94d89b7c048277d0a5a0945d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "329925b90ad5a604cf91248d924ec6c33d519504f59f37adce91040db2b426a0"
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
