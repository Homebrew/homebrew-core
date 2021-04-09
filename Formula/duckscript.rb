class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.1.tar.gz"
  sha256 "2ff56f80ed1d57a7fffc1f09b9fd7481a79d7815c7947cbff5e746f819f1aa3a"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c0d0a1863df44b72e28dc15fd27ceece212cff748203b9b958b3bbbd6567b3e"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ec1cd3b275985be201979fd4392523e279c13e6543e1fbd246766da8e04a57f"
    sha256 cellar: :any_skip_relocation, catalina:      "2edd02358821010a840afe0cd3d65419840d0cd1737abf3214c56d5ab4248028"
    sha256 cellar: :any_skip_relocation, mojave:        "42fa3a52dc5be789deea08c481d3a4bb7d3d06343687e5a9617e55638d881060"
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
