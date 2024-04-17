class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.21.tar.gz"
  sha256 "e19edfdb601f4c6455b7c23809a54de2b6c18544cd868f6bc486ccde8285c14c"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0f6090ec7f0497b5585f211936bb74f140213c273a5fc4864a2cae25be000c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e8e6fb333a58b5f26a400cc3e6de4c252d31dbe2a4c16e52dbb2db196e1eb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46e663a986039e5071055297e823767202e4394754eb4b73e29368ff8c33c908"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c9f0c90175ff75ace48cbf4a6ae023ca7006019018d7474054ce10518efcfae"
    sha256 cellar: :any_skip_relocation, ventura:        "edb2de67cac9584449583a2711dd53847410096388f10d812ff2f0b3a3c0973e"
    sha256 cellar: :any_skip_relocation, monterey:       "e83f4e2b6f6a59af1b9bd795a34ade00ab88db9609c361ca6ecaa16b77f3599a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1feed97684b3137703eb1e1dc41516b73401e24c8d6b18aaa3157eeeea8894"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
