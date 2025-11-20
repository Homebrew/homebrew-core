class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e959f05da5797bccad20b2a9b821b133700d1adf12159c74c30cb5a805503580"
    sha256 cellar: :any,                 arm64_sequoia: "0c3715697a0606d21095be44571c74bc6ccae6f37b4a571147e9dbda8371e1c2"
    sha256 cellar: :any,                 arm64_sonoma:  "2871cbf6f441743f95fa87fa5623db755873a7275f8f1ae7b1a25f2cec3e165a"
    sha256 cellar: :any,                 sonoma:        "8903d1f226db631bf633237b50db3ce0a99b70ec6af9f3d16ac80117e1763e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb527b91d9d6d66c29c235a46e716b590cefef5cd5b8b938c18ddd3363fc4e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "488aa015e30852a8673c59da4aaa89afe795d787b63e6a7c3826d7657bf6117d"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/c4/01/41f63d66a801a561c9e335523516bd5f761bc43cc61f8b75918306bf2da8/pyaml-25.7.0.tar.gz"
    sha256 "e113a64ec16881bf2b092e2beb84b7dcf1bd98096ad17f5f14e8fb782a75d99b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/ae/40/9366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57aca/zxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}/pimport --list-importers")
    assert_match(/The \d+ supported password managers are:/, importers)

    exporters = shell_output("#{bin}/pimport --list-exporters")
    assert_match(/The \d+ supported exporter password managers are/, exporters)
  end
end
