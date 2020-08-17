class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.23.0.tar.gz"
  sha256 "b7e1ffc8927e41e5bfbc16081245b6e27ed6afa1b22f3a7792a4732d040db235"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "faf8db7b543fa2aa963634b17173b3971c538da824ec088685ad1b05964b708b" => :catalina
    sha256 "f52b6b64dc7b83f26c0cfdf3f4da90459f3fdf041540938ef91b1b760845e2d8" => :mojave
    sha256 "5eb1507bcdc402758bc043ad63654a9cc466fb7ecb24242003dd40bd07a5ea06" => :high_sierra
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
