class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.60.0.tar.gz"
  sha256 "addf8d0df67dea1d6cfdb8eb297ccae660739688c9932c12569494eff19a14cc"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2336679deb1445a7887d828673445d364825080af6edbcde32d667dc9985ea5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b287d083d01c184e68d23191d7c20231b0bc563ffc3d9cce8c1f768f78a4a94"
    sha256 cellar: :any_skip_relocation, monterey:       "1d7bf306c40aca76e95884369545921f69867ea01b735d3cce2153a9258d6875"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dc94466b808f054cbc061ae43c87c3fbf8dbd9d99ab6847242b46a7898d865c"
    sha256 cellar: :any_skip_relocation, catalina:       "8efb9b8132ddaf7919dda413745569936d597b07545baf14e2b6adc4b0dcc3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1563c412f0e7f5d3f6c9b1f7f37bcc183714fbc5641d2f97ba8ca26664cdec"
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
