class Brag < Formula
  desc "Download and assemble multipart binaries from newsgroups"
  homepage "https://brag.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/brag/brag/1.4.3/brag-1.4.3.tar.gz"
  sha256 "f2c8110c38805c31ad181f4737c26e766dc8ecfa2bce158197b985be892cece6"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "112ddb2485aa0730c63d109081ccf086ca5c83c0de724cb1914722f63e4ea8ad"
  end

  depends_on "uudeview"

  on_linux do
    depends_on "tcl-tk@8"
  end

  def install
    bin.install "brag"
    # macOS needs /usr/bin before #{HOMEBREW_PREFIX}/bin to avoid incompatible TCL 9.
    # We prepend both PATH on all OS to retain `all` bottle.
    bin.env_script_all_files libexec, PATH: "#{Formula["tcl-tk@8"].opt_bin}:/usr/bin:${PATH}"
    man1.install "brag.1"
  end

  test do
    system bin/"brag", "-s", "nntp.perl.org", "-L"
  end
end
