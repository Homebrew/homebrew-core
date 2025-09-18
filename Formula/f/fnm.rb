class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "c24e4c26183a4d88a33e343902ed2d45da23e78c66b2a696a7420eb86deddda9"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64782e66d6b171629e37d30437799aeada431a3c6be452f263656753433b37df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e9803d57adb2d02e7880b8bd607248edcf60a2f1987d2a43c12bf42ceae62a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ed0f6e703bc246c9f9728c26948f4d7671e3b79ff42e0e44a455be57b3e5fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69b22dacd824d71438a318fe052ea47e0e1b21fa1ce018e582f0466025fceac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "356ec74426ac56b9f1072243bbee635fa9b799c815cf1d613e37ad40161d3f4e"
    sha256 cellar: :any_skip_relocation, ventura:       "a64ba998422c590b865e0a4f22f1b907b5696e6c1d7559f07b0329252a83d6c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079d84bfb759a70fe095a69f8b0eed08f6c2c45921f075e37e3eeefee7b19139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e75d81775dc5b7bd16cbb6fdc414db5a9693dc8eaa5cffc0802c086d33c6fe3"
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
