class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.49.0.tar.gz"
  sha256 "8ba03a5258151a0dc520511fd5d13192b1b318d6a442acc91fb4dc9ff9d728cd"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_tahoe:   "ebbf830e8d2003329735715cb5d1ea7ca40419ce3c559ec3be24df4e844fdf92"
    sha256 arm64_sequoia: "78333f52d40447a680acb8447619f255b9056edda3b2a6b7f37fa92f3e57dd59"
    sha256 arm64_sonoma:  "29223531f584ec3f46e96bb704fc11e16d026f954d3d3e4773b62ab11df99ed8"
    sha256 arm64_linux:   "f1700517106f6ebcf1fc96d2f88960e90ab6551c4a5abb66a0cd95e4ecf6d8f3"
    sha256 x86_64_linux:  "682d8cbafbb0993acffcd7ccde9fe3c2d4180e330520a7f92bc281341f895f57"
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
