class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.5.0.tar.gz"
  sha256 "763f44ae37c27d98f0ef32eebdef94b7409f3d25208c152e50af48e4c073256c"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce139d78d0067b14acbb609a84333f84adbc17331baa52c9f36a907180885446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3693c393cbdf6530012618ccc76baa0c097e070a8027a1325053f8acf981eae"
    sha256 cellar: :any_skip_relocation, monterey:       "6dcff917bd53406a5fdb6e72b9063227c9c87d4310bb0431f5ea9c55bfeb622f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0fc8e64d2377bdfef80fce6108a88a99fca74eb7351f35340990482fabbbb73"
    sha256 cellar: :any_skip_relocation, catalina:       "11647d250ab6850ba72e7d7d98e066ac05c71779f2392e6c28d093e55abb5288"
    sha256 cellar: :any_skip_relocation, mojave:         "94358e4baccec0ba2b96dc17e1bdab41498379a4e7942fc31d02387f275b9ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a720e4afa810982b69431c4ebe370555e073b277aaa1f889399aeb36bf272255"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
