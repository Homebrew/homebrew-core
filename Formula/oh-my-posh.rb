class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.31.1.tar.gz"
  sha256 "d687024c4b67277ea8022b70c9d538b3eff805f6f37fc6540c85a46eb81ef142"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d1359cd2adc49c321735698b6f58c3150f6748a2a2704ddfa1030b301219e76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2592949ec80fac019520f7cac6a9b7b2f2d1584be7224298247a32e24837b0ed"
    sha256 cellar: :any_skip_relocation, monterey:       "d3e86aa80e80b858de37b6f44bf51f69040c09863f61ebb3880e8af3f467241a"
    sha256 cellar: :any_skip_relocation, big_sur:        "846dbf911884ace1a8d94ee18ee2a74d1719e8ecfbd5d1c6c8c861fe4343c440"
    sha256 cellar: :any_skip_relocation, catalina:       "4f9ab650df99178d37ba9ab83609bfc606195480a445dfaa7d9142ae4489bdca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0c054265ba288d99f502e9b1a13c1a63b3076134f02a0386abfbfe3fc2ad8e"
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
