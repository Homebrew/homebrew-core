class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.51.0.tar.gz"
  sha256 "4eedce9cf55123b550fe1abe2b895d9a2159d0f242ed6da28a2685aacbaf47a7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_golden_gate: "09f8dd625dc35136a4e9d374a82c789e6a79c38f4906ce2fbd1090f1dae5698d"
    sha256 arm64_tahoe:       "bf9f1ebeb16e9d53a7508198601c6b612fd9b851470fd411141a7479f260b7dd"
    sha256 arm64_sequoia:     "8dbb7c7026b4271811e090ffcd10413f7be50cbcc1bdf4acff1e04ba8db7f3ef"
    sha256 arm64_linux:       "2d163de22924a02697a564e85a184b35f2f3431f061be2ca04c289a2a884a01f"
    sha256 x86_64_linux:      "0e7c4bb606c5f550f066d3c4eba6c1e1aa5e32e1f87187bc2fb19c0a2186731b"
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
