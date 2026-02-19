class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/refs/tags/0.11.1.tar.gz"
  sha256 "2e23b16359fb9b2c521f0bd250f6eb754bcb8ef40a7f8bf8076f87387276032a"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "511837c8de4a2edc3cec770ac4a5d732767cf3074755cb58cb14b359be3647a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5582ec1f3830f0ba37bd1562663c64df16dec7249edea7abf44b8d4a4283e912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d23b3da8b2b44581e7f0dfe911f8e1edd43279a88aded7ea8d5e025d35972ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f462e56f82dcf7e2a30276ba5b9f43f310ee9de6c1143fc7da8d481cc195a436"
    sha256 cellar: :any_skip_relocation, sonoma:        "0821ca6f519677e8504aeb4307b2f9c2fbfa6a7423eff300e2a8da4e6aae966a"
    sha256 cellar: :any_skip_relocation, ventura:       "8dd3fca5e3317481cd6d2e8c0d4d83b66de311179eec5fd7fb04a43e14bd3ebc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea5de2c68d6c5afabb1ebfd8b0551911c627bad105f050d87f489a295c04eb98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5235e7033e0a8ed818f198f52df387bd1d82422000c9a32297b7265df247ac36"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  conflicts_with "duck", because: "both install `duck` binaries"

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
