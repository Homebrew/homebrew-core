class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "8ddf812157c4d0e999b2fadc25b9c13665528df08086114d575eee265973b81a"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23baf66aa217c44fa52dce9b7e9e57db48e824aecd8f71ff8317095616bef3d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9654c1dd291ba19a7f968270bad5c33f63274c9b7ce700971e0fa4a8418004a"
    sha256 cellar: :any_skip_relocation, monterey:       "ee23b2f2b1885a81f48e9b6529fe9cdb030cd4fc0562bc6f54ebebececb6a87c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bab2b3e9428e7a579d96028eb26f107581c7e4511cba80500f634ea998de2c9"
    sha256 cellar: :any_skip_relocation, catalina:       "108c7bc622cddba7784d6cc96adc6e026a42914f110eaaba50784b238c247af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0490ba511363f3dc1ee1f68650b3efb28c157d71f39bcb60b550e9b4a4b7aff9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
