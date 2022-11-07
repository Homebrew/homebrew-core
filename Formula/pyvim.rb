class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https://github.com/prompt-toolkit/pyvim"
  url "https://files.pythonhosted.org/packages/c3/31/04e144ec3a3a0303e3ef1ef9c6c1ec8a3b5ba9e88b98d21442d9152783c1/pyvim-3.0.3.tar.gz"
  sha256 "2a3506690f73a79dd02cdc45f872d3edf20a214d4c3666d12459e2ce5b644baa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15f32fb0a34a55dc463c295c8128850cdf204943e7131a9a3dc9a9fdae3ecdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc63addea95214544eda8ef234bd2b4a20ccecda3eb456d4b9074334650fb79"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7d8400d12f030798fed3248e94f6e10f37cca3b39988a4d2a3d32c8686daab"
    sha256 cellar: :any_skip_relocation, big_sur:        "b92f0c634710abccc00652d23f09a89e47cc30bf52f314b45967075d395c097c"
    sha256 cellar: :any_skip_relocation, catalina:       "2d3021b4381d4953a397b284a4291b1e2c50e5632975dd914ba6b03750e78ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e74725182c80d2c3d325e7dd6d7cfd71bb72e94c32552246206d006d94dd889"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/e2/d9/1009dbb3811fee624af34df9f460f92b51edac528af316eb5770f9fbd2e1/prompt_toolkit-3.0.32.tar.gz"
    sha256 "e7f2129cba4ff3b3656bbdda0e74ee00d2f874a8bcdb9dd16f5fec7b3e173cae"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/07/92/f0cb5381f752e89a598dd2850941e7f570ac3cb8ea4a344854de486db152/pyflakes-2.5.0.tar.gz"
    sha256 "491feb020dca48ccc562a8c0cbe8df07ee13078df59813b83959cbdada312ea3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Need a pty due to https://github.com/prompt-toolkit/pyvim/issues/101
    require "pty"
    PTY.spawn(bin/"pyvim", "--help") do |r, _w, _pid|
      assert_match "Vim clone", r.read
    end
  end
end
