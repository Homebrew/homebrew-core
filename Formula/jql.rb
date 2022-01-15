class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.7.tar.gz"
  sha256 "cce5e6b0c5523526e2d70f57895c336cf31c4f87a8d0c59f94e6a3d7ed35713d"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f65f5503dc665a9f03199b24605e35a1b4faac2610631c242e369fae6e1786"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e1a449e8ec8e247d704d01b2afb393a11b6a3311b4defb08d0298e015efd5fe"
    sha256 cellar: :any_skip_relocation, monterey:       "27f2c0a00a60b394dacd6a193b2c807c975573bf9f5ebcb547060c08075b6557"
    sha256 cellar: :any_skip_relocation, big_sur:        "f41c2ea0330e4a856e8fd05a97078fbf4cff3d84a2413aed24a087f87296d2bf"
    sha256 cellar: :any_skip_relocation, catalina:       "a2362a9b2853f641ee0dba3d2ca265de8a0268e885c166226945a3daa39b32b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c332db54e027bb932de4d5aded6547adda1972716e862f04fb516474b658d0f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
