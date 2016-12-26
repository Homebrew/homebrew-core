class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "http://gitless.com/"
  url "https://github.com/sdg-mit/gitless/archive/v0.8.5.tar.gz"
  sha256 "c93f8f558d05f41777ae36fab7434cfcdb13035ae2220893d5ee222ced1e7b9f"

  bottle do
    cellar :any
    sha256 "bd1545c968545a16a7e31ccfa25831ff0876b16211b55bf9ddb3d0bda64ee09c" => :sierra
    sha256 "2c2bc83a6dbd36d8a633bea71c0ce3d788bd94eb5a2285b48ba6f16329968757" => :el_capitan
    sha256 "25bf5005b47da1e75fb3757d213d1e77d6ec3f129de2d1ab3446c2b3a6ae6d1e" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libgit2"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/29/fb/fd98403ed4ec5554ed4f6de3719d2c672ca2518598061ff7231301ff864b/pygit2-0.24.2.tar.gz"
    sha256 "2aae85836c3a8da686220db7db05f91f8797e37edf91cc2a1f88b09fb653166a"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/2e/b8/9920bfdf91a3ffaa23aed32c8438857b2bcec40f2f8babfe0862f7da8fa7/sh-1.12.8.tar.gz"
    sha256 "06e51b2f4c6429be7be48ef0e3439bc7f939d57100dd0febb408291af3fe55f3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gl", "init"
    system "git", "config", "user.name", "Gitless Install"
    system "git", "config", "user.email", "Gitless@Install"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"gl", "track", "haunted", "house"
    system bin/"gl", "commit", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("git ls-files").strip
  end
end
