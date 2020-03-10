class Pssh < Formula
  include Language::Python::Virtualenv
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "15a2e96dc3e0a2f8bc5e757d98db2f846169bd119dacd9e48d21cc0ca3cf9681" => :catalina
    sha256 "fd0ad782abf8cd1c26ad22dee75cbff7752e1d802e2f2b6012baf49c4e37811f" => :mojave
    sha256 "63e2c5fff24e3c39e7c905d6baf2bb47bc0fc5a5299fa2afceccb9c6e914eb15" => :high_sierra
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
