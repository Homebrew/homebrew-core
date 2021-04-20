class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/68/7d/8066c39289bda86c606350aca46b05e157eed2b6391af75b5745cbd6f61c/archey4-4.11.0.tar.gz"
  sha256 "18113b18282ea0ab31acd74d22d2830160ddf0efc82438e328b3ca9823e15666"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b028fd2cb8db0f6e3aad92358612898f7caa096989c895414860870d373fdc0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "43e8e72c61372aea737b852c1f78d3085fc51c7af6fd14f3dc0ce8fb49f2c410"
    sha256 cellar: :any_skip_relocation, catalina:      "94925f9669187217e3e9000dcf95d9333096cdbc0dc98e953906eac94dcfb754"
    sha256 cellar: :any_skip_relocation, mojave:        "cea0bd5bb7adf281dd231ea9ae3e12d33914aff934eabe11568e3ae7794fbf05"
  end

  depends_on "python@3.9"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/archey -v"))
    assert_match(/BSD|Linux|macOS/i, shell_output("#{bin}/archey -j"))
  end
end
