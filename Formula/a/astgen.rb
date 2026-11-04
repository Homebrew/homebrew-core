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
    rebuild 1
    sha256 arm64_golden_gate: "b59135404d101e0de6e2813b9d3fb75edbae944e75204b30c29ec7f925c56721"
    sha256 arm64_tahoe:       "de740da0d6a53ef950aba70b4c0dd83d61a8ec2b892f0597512a14c55c7ee09c"
    sha256 arm64_sequoia:     "886dd3e61be5cd73ed610098808a3a10fcddf3bafc32c0ca1171c7d56a320c60"
    sha256 arm64_linux:       "26463015aec2360b386f9836d8f82c3c62ac6f28798ba4345f9f0e785caf9086"
    sha256 x86_64_linux:      "eebc1f0837bae9112ec9405ce868dbc4d633dd68e8c117b1a72b8cce10b6f91a"
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
