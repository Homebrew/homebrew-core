class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "http://gitless.com/"
  url "https://github.com/sdg-mit/gitless/archive/v0.8.4.tar.gz"
  sha256 "ecde4887eb20109a0345a1bfee420140522f981deff335d552908a00952853c8"

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
    url "https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a/cffi-1.8.3.tar.gz"
    sha256 "c321bd46faa7847261b89c0469569530cad5a41976bb6dba8202c0159f476568"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/aa/56/84dcce942a48d4b7b970cfb7a779b8db1d904e5ec5f71e7a67a63a23a4e2/pygit2-0.24.1.tar.gz"
    sha256 "4d1d0196b38d6012faf0a7c45e235c208315672b6035da504566c605ba494064"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/39/ca/1db6ebefdde0a7b5fb639ebc0527d8aab1cdc6119a8e4ac7c1c0cc222ec5/sh-1.11.tar.gz"
    sha256 "590fb9b84abf8b1f560df92d73d87965f1e85c6b8330f8a5f6b336b36f0559a4"
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
