class Beautysh < Formula
  include Language::Python::Virtualenv

  desc "Bash beautifier"
  homepage "https://github.com/lovesegfault/beautysh"
  url "https://files.pythonhosted.org/packages/20/96/0b7545646b036d7fa8c27fa6239ad6aeed4e83e22c1d3e408a036fb3d430/beautysh-6.2.1.tar.gz"
  sha256 "423e0c87cccf2af21cae9a75e04e0a42bc6ce28469c001ee8730242e10a45acd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "db3fc03fcc098082ae52debdee0bc7f353b793207d1cff2c05ea98f9d991bc83"
  end

  depends_on "python@3.13"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "types-colorama" do
    url "https://files.pythonhosted.org/packages/59/73/0fb0b9fe4964b45b2a06ed41b60c352752626db46aa0fb70a49a9e283a75/types-colorama-0.4.15.20240311.tar.gz"
    sha256 "a28e7f98d17d2b14fb9565d32388e419f4108f557a7d939a66319969b2b99c7a"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/13/5e/3d46cd143913bd51dde973cd23b1d412de9662b08a3b8c213f26b265e6f1/types-setuptools-57.4.18.tar.gz"
    sha256 "8ee03d823fe7fda0bd35faeae33d35cb5c25b497263e6a58b34c4cfd05f40bcf"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux
  # https://github.com/lovesegfault/beautysh/pull/247
  patch do
    url "https://github.com/lovesegfault/beautysh/commit/5f4fcac083fa68568a50f3c2bcee3ead0f3ca7c5.patch?full_index=1"
    sha256 "26264ebaa3b4f3d65ea382fb126e77b64974a1eb26fda297558c5aad7620cb1b"
  end

  # Replace setuptools for python 3.12+: https://github.com/lovesegfault/beautysh/pull/251
  patch do
    url "https://github.com/lovesegfault/beautysh/commit/2d0486cd4751d828ee0ba70c9c78c8d8f778b6fa.patch?full_index=1"
    sha256 "2836af4805504339c1aa3bab1c14678e35d6eaaf2310c462b097b736d277b2be"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.sh"
    test_file.write <<~SHELL
      #!/bin/bash
          echo "Hello, World!"
    SHELL

    system bin/"beautysh", test_file

    assert_equal <<~SHELL, test_file.read
      #!/bin/bash
      echo "Hello, World!"
    SHELL

    assert_match version.to_s, shell_output("#{bin}/beautysh --version")
  end
end
