class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "0362d1844db2c2adaffcb0a315fa5fa6c30ae05a0810affb63ab7270eab17cc2"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a07d8d3154be6490f141dc453d69b746f33cfb1012995be5b6634fce80f18f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93ed28badbd48f2e498b069efc036b4967c141a80505d8823df780fa9b3accc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4118339e23b456fefcfeb7c1ef192dbf733d3b93fc839514c1251237862e4154"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4679aa9b5d17fc0e51ece4cd1fe2291c722f93dc8a55e91a1fe88af90bd1c1c"
    sha256 cellar: :any,                 arm64_linux:   "7bff3fc87fe117b2eee8a9e8c63258a175a92cda52ec599523f5f4d6bc998427"
    sha256 cellar: :any,                 x86_64_linux:  "6601a2161882705d5227ffed702eb5ae7a9cac7cf798cfa0b2aab798e138d317"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
