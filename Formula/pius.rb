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
    sha256 "47a73a40992522c5834b81bc8f6888db64b2ae381e6e2287fa1e1fac366347b7" => :el_capitan
    sha256 "8d9e44165fa23aa04484118977188186ff0becd0fbf6cbd498ea88121322ac15" => :yosemite
    sha256 "8879e7d0fc7970e838091dfaed8b1d36676528cc185cdda4908c63858b8b124b" => :mavericks
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
