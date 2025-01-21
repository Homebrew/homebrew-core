class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "39f7c33a05ea1e608c4fa4918bb615b1f75eabbbb848c129436c43484967b74d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1018d56e8435e55660cddbd5d663eb1842334c7fa1a57f621ef1c12c3290a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cb3ffc2a6c8cbff5315e13924888eccc9698666454cdc5a231709b699a67a21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc7de9e0c5ef2285ca5f5eaee9d73a9275421d9c4504ecadffda72248cdbfb65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb85d61873f4e0f3fae6fd901dbac6cb75af53f6d78b6ed885fe394ea41518e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "cefacc34490a7858b4bf11b5eed811b9af1e793f9cbe7dfc6126b4e7402a3ffa"
    sha256 cellar: :any_skip_relocation, ventura:        "541994648e535ea2a1de637cfa6c4ccae5116306c3aeae814f476bb24e9a6cbc"
    sha256 cellar: :any_skip_relocation, monterey:       "a5708e73b0d5a14278f9ce4a872067f21227ea7a35979b9fc6457fa7616ff6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed55adca064e41f0d8c3f9794d9d4b208812f5b3d810a1e98f02b495196c0a3a"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_predicate testpath/"clive.yml", :exist?

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
