class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "984d2097529ca9cdb24c6553cf55e1001275864462dd06a8de4f338c339a0fff"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9dcd2934f709d778a9a12fe6501a4841458815d17c2742d2f26a23318b19018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f474f9b9da2353a86cdf6f03ef2303a27375c3e087a60bde11731d0636a754d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eac1b4cc09a3c34d2d01ec190bdb078c5131921b848d32705e9f9732046b51c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0335f7c9a2f6355f7e3e641065364d41d00c8cdc0ca3be607b2d8cb6ab40388"
    sha256 cellar: :any_skip_relocation, ventura:       "876f21408b2551e6897802245642bd7d2e64f2d6481a059a38a4a37af20e663a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ff45ce008244d621f237f1471d76def4c00d9c637e284f46128fc6b008dfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e43054ff1385d4a6fda830232e0d07b448bd2f2b577f6378c9f3cd7e6994558"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
