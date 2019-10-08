class Pssh < Formula
  include Language::Python::Virtualenv
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "37ba25ad7e68af9c2b5e855fbc6bac62df503b0f2c19a3c768ed753b8bdf9a66" => :catalina
    sha256 "f629be84f06086697723f5c81bcdddb86fcf97712663062e909b8921c4ab6793" => :mojave
    sha256 "f6defeaef5356d64010c322358bb1d66769352db4b1d61c1a47f123075cf288c" => :high_sierra
  end

  depends_on "python"

  conflicts_with "putty", :because => "both install `pscp` binaries"

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
