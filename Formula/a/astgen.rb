class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.50.1.tar.gz"
  sha256 "8d9728dca8eab694a0f07bcd7a1c9a88368cb7bd354fc19c2ee8ca8611ff869a"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_golden_gate: "f4e17b94198dbdd4cc8dc1eb5d816e50eac6af367fec84e151c082cfa3974437"
    sha256 arm64_tahoe:       "52fc4b1ad752ea49c557940a422e6bf04d3d7587edb6671a9fdd646a8747101d"
    sha256 arm64_sequoia:     "ca7a9223c1b018c3570c9c4e57866f8000ab265e050a175226fe69274b8f35b9"
    sha256 arm64_sonoma:      "85a63b704378534a04a02807285da837e9a63863e72345fce1a03daa547e8f5b"
    sha256 arm64_linux:       "794207481248c1914761b50ae0e56b6f895c784f99100eb9798ee9acf8663168"
    sha256 x86_64_linux:      "bbfd253c4e20b11fc241eae0bdcfc4fbcd16c655e4e2f06604e12d5e606e830c"
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
