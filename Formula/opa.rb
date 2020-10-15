class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.24.0.tar.gz"
  sha256 "6401f8ce1c99fe90fddd27e1fb54b04477faee8d6ce0a1e4565405df26e47383"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f232fca4be0ec90905d33fb487cdbe872947e9ca1630bd81191c80946127642" => :catalina
    sha256 "aeb1715b15a432775184cfc0d0dd17f45bdfcae4a6bda508d118e4bfa77e297a" => :mojave
    sha256 "b4f3d4d9ca0c2032ac0488d5fd355b69b7bbe3446ff79dae1ec0bcf3eef2fa2b" => :high_sierra
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
