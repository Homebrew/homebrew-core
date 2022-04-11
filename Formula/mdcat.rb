class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://codeberg.org/flausch/mdcat"
  url "https://codeberg.org/flausch/mdcat/archive/mdcat-0.27.0.tar.gz"
  sha256 "5c9c2a19ed1e1c0e766094f2ecebda5df37942b96df7a0a87a6681a66a684af2"
  license "MPL-2.0"
  head "https://codeberg.org/flausch/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b8482cac7a6ff3b84999bca961ce781a308f2c8b85942ccb9d9dc01bef77d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c587e22c8897f17e1c118f6ba43a051348706e66510317ad9e5e912346d371e8"
    sha256 cellar: :any_skip_relocation, monterey:       "8ec378322faf9031245452e40380a062fd49e3e8e002aa64a1be1fbd8eaac00a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b3e421f2f1d1de1585064c70217da2ba79f52389006e1b1f90295d7243a2adc"
    sha256 cellar: :any_skip_relocation, catalina:       "afab085c88ffa799df153867a2ec49d451272fc15b5e7d27135ab7a2f486fd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fea82da505ebeb846172efd4afcfd884a81d6d5d57d63484f1c16fb0eb97d4a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
