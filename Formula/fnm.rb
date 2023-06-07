class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.33.1.tar.gz"
  sha256 "84a2173a47f942d1247a08348a20b3cdf4cb906b9f0a662585dc1784256d73c2"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b934b7bcace92f5522c5afbc265f4f98eb603520d0badf00d34a180b01f88375"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09863938f0c2a807b934dfbee0faafb57d9e01c33b4cf0c9ce47e9d475ad7f6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdd4644c7f569e85ba12b8f2b20dd1fca764166e506fccaa77d89859a1a1efdd"
    sha256 cellar: :any_skip_relocation, ventura:        "cf47b704db8c4230bb44f4b5b96637375f1c05d28a8d3a36b9c26ea5bf6eec67"
    sha256 cellar: :any_skip_relocation, monterey:       "ee9e0eb2a4c9fd6de12a198da932552cd0d1e2a9711f6c49e416bd69e4f7eb20"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a88221f93e75572a06523f2b464dd3df14cc4bedda3f3fe267825d38141ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216eadf9087a9c22b10b42274af93fb370e85cb159f894c7a1972ba4bcd74df9"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end
