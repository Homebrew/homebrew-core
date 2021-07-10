class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.3.tar.gz"
  sha256 "6bf687624886bad62f2e92159cb9ca6e29c4a856f3ddf23bb2b90cb27b4891eb"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3ca2f6c89a1c90f840eeb06b7803dff21d6f84ff974a9848f8efe0c0bb91248"
    sha256 cellar: :any_skip_relocation, big_sur:       "78113fd5721e77136e5716028dd64364d0250915638ae83566417341e5fc9ff1"
    sha256 cellar: :any_skip_relocation, catalina:      "31c479e8f139af03ca9869778c0fa7ff01131bf8100fb62c5f08a961d1881324"
    sha256 cellar: :any_skip_relocation, mojave:        "35949284d8a22eb7187266077ece7bfc557b77749165e6d37ed03581161ca49f"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
