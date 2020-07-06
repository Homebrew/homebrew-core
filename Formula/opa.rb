class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.21.0.tar.gz"
  sha256 "dde2c49e1d133216da8ce33b0d5276a00dfea18535ed91ca3b3fad514ec0175d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad97bf77534ea5b72012148ec96e08700b1762b89f1222738e5c51f43c74f5d8" => :catalina
    sha256 "8ef806fc00001368ac78a50df08024c0b52d76438b1f7963ab9d71e02c045b4f" => :mojave
    sha256 "271f1584b341382fd5f9b5f601707d4fcb0efe96b66d82bf958221f091a287a9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
