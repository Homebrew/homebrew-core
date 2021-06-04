class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.29.4.tar.gz"
  sha256 "f9b1926d9149aab07b19f3f558f698c96db39216b166b7a4ca45dbf3471e2f08"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b0f699e0dbd5b7259ad0061909a6f2e6ae7db77f62152721238cda2c0dc8e2f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7223cb375b1f7108325ff126341b3d4642e019468993aaaa9789916d233a19a"
    sha256 cellar: :any_skip_relocation, catalina:      "28d1149bf4040790b7a4af3c0d647cb36a529304fa6debd502135c76d7990b2a"
    sha256 cellar: :any_skip_relocation, mojave:        "046d4d3fe898d1decf4a7014f39721f9b09f35e59f2e747832bb32eaa61087e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
