class Bazaar < Formula
  desc "Friendly powerful distributed version control system"
  homepage "https://bazaar.canonical.com/"
  url "https://launchpad.net/bzr/2.7/2.7.0/+download/bzr-2.7.0.tar.gz"
  sha256 "0d451227b705a0dd21d8408353fe7e44d3a5069e6c4c26e5f146f1314b8fdab3"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c9ab575e1e27fe8e550690c760464c37890ca5c1fa8ea111c74d0172d0fa1453" => :catalina
    sha256 "32411a9e28eb27b3637bc915150581524897a18ba223313e5bc2f776785aae9b" => :mojave
    sha256 "cb1c0c8b5f19abef4043195d8cbd19f363a78581596de1ddcc763621964335b3" => :high_sierra
  end

  uses_from_macos "python@2"

  # CVE-2017-14176
  # https://bugs.launchpad.net/brz/+bug/1710979
  patch do
    url "https://deb.debian.org/debian/pool/main/b/bzr/bzr_2.7.0+bzr6622-16.debian.tar.xz"
    sha256 "e9b155ff03d37c3ae1f8cd8fede884c74f8c4c88b4051db17fbf9e2060cb9dbf"
    apply "patches/27_fix_sec_ssh"
  end

  def install
    ENV.deparallelize # Builds aren't parallel-safe

    # Make and install man page first
    system "make", "man1/bzr.1"
    man1.install "man1/bzr.1"

    # Put system Python first in path
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin"

    system "make"
    inreplace "bzr", "#! /usr/bin/env python", "#!/usr/bin/python"
    libexec.install "bzr", "bzrlib"

    (bin/"bzr").write_env_script(libexec/"bzr", :BZR_PLUGIN_PATH => "+user:#{HOMEBREW_PREFIX}/share/bazaar/plugins")
  end

  test do
    bzr = "#{bin}/bzr"
    whoami = "Homebrew"
    system bzr, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/bzr whoami")
    system bzr, "init-repo", "sample"
    system bzr, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bzr, "add", "test.txt"
      system bzr, "commit", "-m", "test"
    end
  end
end
