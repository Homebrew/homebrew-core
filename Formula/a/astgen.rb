class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.53.0.tar.gz"
  sha256 "cd7eebd7fae08accab2e119736921dcc6987c79cf701e464b13841a4b1d70d6d"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_golden_gate: "7cc7c9e5510bf51f4f0117072307046bd46154ca422d8e476ad310fc6462c9ee"
    sha256 arm64_tahoe:       "8362862e22c95490b93d9083e2065642e418c20eddba669b1a292683d47e4db2"
    sha256 arm64_sequoia:     "f308a79decbfeb81c15a86d4cfc3a05f8e6ae4f6fe4229da6b22abb85ae1ba42"
    sha256 arm64_linux:       "9949657983d372a42e6e66c8a56017ba788d1a7543715906b7475d7fb07fc31f"
    sha256 x86_64_linux:      "bc1f6e116d76436ba7c61c41ac48e7052f04153160a127644b4033af25f377a9"
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
