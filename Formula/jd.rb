class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.5.2.tar.gz"
  sha256 "ff6cf8fabe65a5786652ab2a3ef762d5dc6b5595a9516f81eb0916fdfe13bab6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bbcbda67881b2814dcd4a13981d37ef8d0051ba73454a14f4a04494212bd55f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d37705ad550374c449e38fae9a8d9eebe70dbe8fe54c934a22c272c5bbf71d89"
    sha256 cellar: :any_skip_relocation, monterey:       "6787dd2164cbaad39c1af3443af87254738ecbd19a7daa3fec47099a79c5e887"
    sha256 cellar: :any_skip_relocation, big_sur:        "c454239f003e514cdea3b953ba9b2dd57840b0056ac1efd60b8159717d707918"
    sha256 cellar: :any_skip_relocation, catalina:       "0c87c0ddc9d208d9017297aa9c317a9f95d472ab3b37fb7b8d55fc8891bc6899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11349f2e5ca1738e5aae8a5bdcd2ce9dc6137f2a9c646b43b85ba2a2a13222d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json", 1)
    assert_equal output, expected
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
