class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.19.0.tar.gz"
  sha256 "4051ad846ef7abacd41927d5e29ac4eb8ab29567a78e28727e1e8236cbaefeff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6264f0f4f0dcccb5f42f62af4cd5271e09a053c6fde1826bd33c9f7b97ddbbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d478dd178d547ee9789c71f7daf46aaf6a0281cfa9785ab147bf5d71135e428"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c6b329cd5e26371da8a62c907de6cb3dca050dee56fd4c1c789681020352bec"
    sha256 cellar: :any_skip_relocation, ventura:        "b499cd1fbcf280ae36584d45c167909a540a553bd694f3c77c7f15670ec64ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "48563eeec2620a2593c3e243435f2ab9090430c91852900c184626beffcab409"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8e8adc6aedd87cb432574f39b51aceb1341d0cab9cf3e519238f18f4b289769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "825c14fc9a6e5f01761e5e7e1677245c325fb2a6fcd0323543f4866675ba084d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
