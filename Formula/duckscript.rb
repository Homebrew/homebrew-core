class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.7.tar.gz"
  sha256 "b2143f0f4660eb61b43da440fbf1c43e2bdefefc657435187e031b2fe671fa22"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "269c31b9837a1f8ac29975f8cb1da4d31a6ced3c839967cc2cd14c9bbfb23cb2"
    sha256 cellar: :any_skip_relocation, big_sur:       "102b5ee7437a0eb4153a27a588eaa859f5143dff2cad599a56f1023452e0e059"
    sha256 cellar: :any_skip_relocation, catalina:      "e0936f8d4d3f6978c31bfdedfaf4ca6a5a11236a7eaac2286f220dedc48d0e69"
    sha256 cellar: :any_skip_relocation, mojave:        "4c71c9af95a277eb63825fedf3c34dede96cdd1409c62d9becd7abce01b7cfba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ddc02686df4599a311edbe0c658d1bbbc1ab5a5947a995fec9adb2707993aa5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
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
