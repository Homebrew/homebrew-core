class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.96.0.tar.gz"
  sha256 "9d04d37fa7cf9d91cbed4ef961310d58227edd69feda3d24abe20cb85e912f0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d3c7c2e84687b7c8dba736f640adc8b3ad55a901a1b3a3a77590fa2bfbeb2e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94b321e04b98ae79592088f3db5069495038bb250bc5ab6f8320d1e7acb1cea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c073f89587c9bc289635e79869514722076cd340745904bf364c30944066c2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c1cce5c8d92dcfcc948287388de78f8b7296446e84628474a678a06581b85ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eedba68eff29a4ce9d9809e84cb1d3ef148f2c7e626356392c087f6ff0c2d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7372f8f61713147f59bd64913424f4297368b2b0c6047e27866d1f5f7523e50"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
