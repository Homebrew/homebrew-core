class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.16.tar.gz"
  sha256 "d5c8aa607986e542746df5b4e68a20b77f32fcbf4d34faea718b09a89b22407e"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83ce5807ba59abadf5f3a5d2254b93fc9f5cb380a3fb2c001d81f79c95705955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7883a647fb0fb7f330fb6366a3685caf6fd79f30ccf2032217a750823a9c1b56"
    sha256 cellar: :any_skip_relocation, monterey:       "b85f270e876aff656f4539aaa50a5ccf7df03fe5b84a30d1c7942a17b4708430"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b75dc490fa64d8f5bc3b86a7475df9e1ce1b769999b5b91487a7a58f0d948e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b100c1686feb48232cc98fd80a420d5527e6d14662eff6c7e397538df4f45856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfbffc50255437f462d89cb0ba05aac1b409a3853d9de1e2bfb466edabaaf365"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

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
