class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.24.0.tar.gz"
  sha256 "6401f8ce1c99fe90fddd27e1fb54b04477faee8d6ce0a1e4565405df26e47383"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf8be1ece184951d4187db8ef85bb75240cc941323e311d844993b1cdadffb73" => :catalina
    sha256 "8ebd3475b2657848a7f93f5be506f795228e20215bd6a325ba99a21d51bd7a2e" => :mojave
    sha256 "649f4d9b1b8ecaae10419308ea90e321000c6f81b735dd70357cc1a6f8c9d387" => :high_sierra
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
