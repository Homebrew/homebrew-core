class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://codeberg.org/flausch/mdcat"
  url "https://codeberg.org/flausch/mdcat/archive/mdcat-0.27.1.tar.gz"
  sha256 "79961e0a842ee0f68aee3d54b39458352664c67388e56175a9d18d80f357bf14"
  license "MPL-2.0"
  head "https://codeberg.org/flausch/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d4b495c466fb64bb3eca0f638ca3c31b4e866f852793d467a6be64d9e0c6e1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27e7b3daaba5e744a6d65d7ca70c6f18b702f47145364cb87db5aa4d0086eb5b"
    sha256 cellar: :any_skip_relocation, monterey:       "b380ee16e3cff91daf99c6a6970c05dd7dae9cf62376d21a752cb49816622e16"
    sha256 cellar: :any_skip_relocation, big_sur:        "dca5bf3fad1ba9950dfccfdbd2ec2be946d35da445efa11cf8b13f28a3d5d2a4"
    sha256 cellar: :any_skip_relocation, catalina:       "b2b05c9cb04ecc18461bbd859625553409cd311e4844a3cee228a9841e9b93cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b04acea14ed19b214c30b4c5a62595f8740340321c9ad8cc996f65436c53017"
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
