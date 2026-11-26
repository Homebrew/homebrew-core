class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.57.0.tar.gz"
  sha256 "024547c95bf47cc50ed024b5514d4ab2240a65049b0655dda4366fcf69731ddf"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    manifest_sha256 "faab273ac0a60cb0868b6c00e167e222d1dc94d410cc7bbf2857de5d420fdd6c"
    sha256 arm64_golden_gate: "8e037eac8ae38678536b7da6ce20944796b6c1d2396671abfd22e204c0dadb85"
    sha256 arm64_tahoe:       "047efa08cc0ecc87c31c827fd0219f0ff58f14505c6cdf4bfe530ad5533a0688"
    sha256 arm64_sequoia:     "e64424a1ac7ec686fc926e3a535725872b4767b5ef9a0c7507666880d0038943"
    sha256 arm64_linux:       "fa7db903829eb097ea052eda51311f17e6b9f06d1248622f2224b4b36dd3ffe6"
    sha256 x86_64_linux:      "310154ab1526d9250ff2ffe569290f88de5867fe53490a21a6cef3f2a16b4598"
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
