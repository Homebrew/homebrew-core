class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/v1.9.0.tar.gz"
  sha256 "acbc80567640f0f3afa75321b1f3a4e5dd2ff126046089ff537ee71dabcb2350"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ff76e7f4650aa977f0d48e0af9acb21c4fb4a1817346cdbc1fece8aaa8effa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "675998e4d801cf74e82bafa118ad4b9deaa67a18db166ef5b94d23d7d0ce94ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aea8a32d9c15e9823a43d4d3f742696d10d2c6366eacb37676587fbc1379d48"
    sha256 cellar: :any_skip_relocation, ventura:        "8c5a3d32c5c868803917727d5bb454fd24f4c3a1dc610a0bc0870b2c7b60ce7c"
    sha256 cellar: :any_skip_relocation, monterey:       "d0cbeac1bd0c3b790d19b5225074ff80d48bc28d045443744f175ed60c1d1f36"
    sha256 cellar: :any_skip_relocation, big_sur:        "40e06a3df7453e30bcb74533c4af307ae2032c93936046a86832fd613460869d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9465d9b80409ab0db25a8c56a9eb006b249f9300c54c205992eae238af516d0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath/"test1-foo.bar", :exist?
    assert_predicate testpath/"test2-foo.bar", :exist?
    refute_predicate testpath/"test1-foo.foo", :exist?
    refute_predicate testpath/"test2-foo.foo", :exist?
  end
end
