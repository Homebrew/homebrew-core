class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v2.1.0",
      revision: "28259ef891536fe5ad068a213f55a7131070709a"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53a880d7655379c18733ef019314c34ab6d3a716f394d8f35c411afb977e9732"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "124a00deff7726afbe57971b87c429412772e6e096c6d4c5cacf1b140cbd46c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e9494cd0fa6f64cf1c88ba52fac3976c35b254a4f460313a30aa8dbe83fd084"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9a175c5640ae31c8e9ee1b6234f4313da91b799fee04b6b1a6027494989d027"
    sha256 cellar: :any_skip_relocation, ventura:        "b8843fe82a5e6eabe0f31fa94d83041b6ee87d2909f7ff9b06acc151e3b312f9"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb6c513a8f75834c2942e1cc2d07267b7b87be1bfde72ca8505c255a89ca4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f2b85f57a508273cf8cf435e3be30215f2acf4d3c1de620be242d855f60b96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
