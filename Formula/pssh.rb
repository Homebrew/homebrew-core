class Pssh < Formula
  include Language::Python::Virtualenv
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "62460d1e1e69472684b09842c05d80e9b6da5f9510815b6d40b527a452067c3c" => :catalina
    sha256 "5b456c61d419a842c5c979a41494c5e2d7c4beb71190a621635a89c9c603c772" => :mojave
    sha256 "c06b726eead0f61a02e2c0a8f6fcdf8cf78f437deb841112b08447829b828e90" => :high_sierra
  end

  depends_on "python@3.8"

  conflicts_with "putty", :because => "both install `pscp` binaries"

  # Fix for Python 3 compatibility
  # https://bugs.archlinux.org/task/46571
  patch do
    url "https://github.com/nplanel/parallel-ssh/commit/ee379dc5.diff?full_index=1"
    sha256 "467df6024d180ea41a7e453b2d4485ef2be2a911410d8845df1b9e6b6dc301ae"
  end

  def install
    # Fixes import error with python3, see https://github.com/lilydjwg/pssh/issues/70
    # fixed in master, should be removed for versions > 2.3.1
    inreplace "psshlib/cli.py", "import version", "from psshlib import version"

    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    system bin/"pssh", "--version"
  end
end
