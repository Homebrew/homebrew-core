class Pssh < Formula
  include Language::Python::Virtualenv
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url "https://www.googleapis.com/download/storage/v1/b/google-code-archive/o/v2%2Fcode.google.com%2Fparallel-ssh%2Fdownloads-page-1.json?&alt=media"
    regex(/pssh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "01d4dbe79b114a2e0a0e0cb10de0279f7872e9ed09036550102989bb9b59cb66" => :catalina
    sha256 "7446d15d9d2fe0579fa3f7c37f5e5958309d4de88ea456b6f6e9aebc3a8e4ced" => :mojave
    sha256 "d01989822798d3d6c6a4b3cd6fba588170128860e9f20300b88035443b915d4b" => :high_sierra
  end

  depends_on "python@3.9"

  conflicts_with "putty", because: "both install `pscp` binaries"

  # Fix for Python 3 compatibility
  # https://bugs.archlinux.org/task/46571
  patch do
    url "https://github.com/nplanel/parallel-ssh/commit/ee379dc5.patch?full_index=1"
    sha256 "79c133072396e5d3d370ec254b7f7ed52abe1d09b5d398880f0e1cfaf988defa"
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
