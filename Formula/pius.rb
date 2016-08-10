class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.2.tar.gz"
  sha256 "2a3a7f1c4ecaa7df46fa7c791387f2de5ef377a8f769fc325ba067d225ebfc79"
  revision 1

  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5f4db30f6c40930fe3dd6201d8df39994b3724def34249b83a5b1f0023485fc" => :el_capitan
    sha256 "6d8c4471d5151e23493ccca5b3b9ea5306fa059802d6576cbce1468fcca65a05" => :yosemite
    sha256 "c89c9802be880c3e400a68eb92341495ac7169e14af285166eb7a985f8473fc5" => :mavericks
  end

  depends_on :gpg => :run

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
    You can specify a different path by editing ~/.pius:
      gpg-path=/path/to/gpg
    EOS
  end

  test do
    system bin/"pius", "-T"
  end
end
