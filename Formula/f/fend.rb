class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "5e973bf7f53416039d5efc2f2ec360add5184625644e986808c21e5bd292fc58"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aaee006c126ede3629a9e6c5ac5368b13b9636880515a67938cff4711d222ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f466d1c519dec8b04b202cbcd15e5353868cd5c4c573f5291ed877e0448c5d04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df034454ca8dedc9ef7e1b65edae3239958f3dba8a621af01721822156eacce"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0a3df950f9efd224083aa984267c91424e2461ebe11914d0743577dc241d30c"
    sha256 cellar: :any_skip_relocation, ventura:        "846d7ca59262bcdf1638a220ee54e02718d5e314d19063452a288e8c7b958c70"
    sha256 cellar: :any_skip_relocation, monterey:       "a914c35f846e32e4b94757646e83e5c67f5dace9c084d8adc7d9d672ce105f56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb69f1d9587797cbebd3367dd75ff90085dbbe255022f94317936158f9c6b6d"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
