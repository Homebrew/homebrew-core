class Pssh < Formula
  include Language::Python::Virtualenv
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "8f48ad9c3d6c59d77e50a85a940e9698482018140475035b274eee45567d5474" => :catalina
    sha256 "fd5a9e13b00695332f468814d5bf2c823713cb7f91f423395996f5f65354f8d6" => :mojave
    sha256 "73f994d5f4b9e8df301351b552108cdc2cf5a99c2899c8f5c929c9111b69187c" => :high_sierra
  end

  depends_on "python"

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
