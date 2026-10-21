class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.51.0.tar.gz"
  sha256 "4eedce9cf55123b550fe1abe2b895d9a2159d0f242ed6da28a2685aacbaf47a7"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_golden_gate: "bdaa10eba658281ce62fa9751087cc49e60dac4cd9d5d5ccfcc373af88efb74e"
    sha256 arm64_tahoe:       "cda544cec0d26dc77519e0f084c08733b4fa4554411acab32c7c0c90d8cf3b8f"
    sha256 arm64_sequoia:     "aadea6e66c86141b13d1ac8d31c33bb0327be1d438ad3788b98833381c249974"
    sha256 arm64_linux:       "0edc9cc08bedf5e57a8d02ab10664775b8780118d68d78212dedde81b41da7a1"
    sha256 x86_64_linux:      "0cd62c0a872de805b475af0f44f81294381ffc7995c0d531009e7f4ff9d68974"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  def install
    cd "javascript-astgen" do
      system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
      system "bun", "run", "binary"

      os = OS.mac? ? "macos" : "linux"
      arch = Hardware::CPU.arm? ? "arm64" : "x64"

      bin.install "astgen-#{os}-#{arch}" => "astgen"
    end
  end

  test do
    (testpath/"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match "\"fullName\":\"#{testpath}/main.js\"", (testpath/"out/main.js.json").read
    assert_match '"0:7":"Console"', (testpath/"out/main.js.typemap").read
  end
end
