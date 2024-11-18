class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v3.20.0.tar.gz"
  sha256 "73dd16943f0bd10e2d171b7a4b056aa10fa0efd1b0f6f41d19584ec83c22597f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a3ff787bb98219536e744663035f15f53b7ee2db59ffee934b0a422fc73476a"
  end

  depends_on "yarn" => :build
  depends_on "node"

  uses_from_macos "zlib"

  def install
    system "yarn"
    system "yarn", "build"
    system "yarn", "binary"

    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    bin.install "astgen-#{os}-#{arch}" => "astgen"
  end

  test do
    test_file = testpath/"main.js"
    test_file.write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match "\"fullName\":\"#{test_file}\"", (testpath/"out/main.js.json").read
    assert_match '"0":"Console"', (testpath/"out/main.js.typemap").read
  end
end
