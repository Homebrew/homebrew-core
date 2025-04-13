class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https://probe.rs"
  url "https://github.com/probe-rs/probe-rs/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "6f37bd7ca85eeac29aea089fa39415b484a74f3415d9f21e94049dfe765325d2"
  license "Apache-2.0"
  head "https://github.com/probe-rs/probe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508ec9c47f72df213ba496904849f96a574322bb8526d4bda346a168f6308eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e32b5cb5ae48ea5cd3c9582e36123874c3b788e3c8742e5cc5926a1de06d31d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bccd39d22e47d157637e9fee024d22993cf6905d670195ec8558532febacc4a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd67fb6caca4c506c2871ac742f577521cd623eb12410fdad1fa19d73b196a07"
    sha256 cellar: :any_skip_relocation, ventura:       "56eb3d189525faa8e5f30727ece08fe63a00671dbc6faf2cb965c888d865c293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0703782d00468dda9288ee373f050699d7755b8e0409353eefd6b185457dec83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08aa999824302d17acc664b8dcabb80d5f2955f56008feb05d1c74500092c001"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "probe-rs-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/probe-rs --version")

    output = shell_output("#{bin}/probe-rs chip list")
    assert_match "nRF52833_xxAA", output # micro:bit v2
    assert_match "STM32F3 Series", output
  end
end
