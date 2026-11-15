class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.55.0.tar.gz"
  sha256 "7a51af1d288e2d112ad3f346003f41916519562ee773377ffd8e7ae0eb95cb38"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_golden_gate: "3b4b6b3ee5f463665586d7a0a7200562769faf3231c8237032913c7730d25ac1"
    sha256 arm64_tahoe:       "d10669c5ea3fb5b90ec4c904f2693d04c9b219bb505caa1e0c22af26f57de3b5"
    sha256 arm64_sequoia:     "eb5249c7876f5c5a8718c52e1effc61be5569f98b7da7713c457e7804be64863"
    sha256 arm64_linux:       "99f46a5de18be6f9c9617df47d1cae95e8b0dddb2650f086e400be7c9bcc6da4"
    sha256 x86_64_linux:      "c043d70763908c901ee38ae1b6dcfc99f0314b918ef6c6ca1517862d1c9b842f"
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
