class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.54.0.tar.gz"
  sha256 "01afc46ca05455fc078289eb2716b1d1627041a8f5d06c4c94e955ef09d9d400"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_golden_gate: "4f810e6242424019691dc42674cee45ac3d9c14e8a597f1d44d5b9e5c01b037e"
    sha256 arm64_tahoe:       "bfb3f95c437d66460459e3046ca48f4d21b00e2d6c29fdec259a54db9e7d9bb9"
    sha256 arm64_sequoia:     "7adb596bc493e586bc3db9dc9db63aedd408d36bbcb73843a97b42ee9aed84f3"
    sha256 arm64_linux:       "7534bf4cd97a6b9a64a30be81d943da3f566442b42f63528312136acbc2eb757"
    sha256 x86_64_linux:      "bf102bcf10d8a79a0f8133f15341d997d05158c00238963580258ca65cbaf2ab"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@79"
  end

  deny_network_access!

  def fetch
    cd "javascript-astgen" do
      system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    end
  end

  def install
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    cd "javascript-astgen" do
      # Only build the host target, as cross-compiling downloads the other targets' bun runtimes
      inreplace "scripts/build-binaries.ts", "targets.map(",
                "targets.filter(({outfile}) => outfile === \"./astgen-#{os}-#{arch}\").map("
      system "bun", "run", "binary"

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
