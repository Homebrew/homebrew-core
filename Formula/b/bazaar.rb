class Bazaar < Formula
  desc "Friendly powerful distributed version control system"
  homepage "https://bazaar.canonical.com/"
  url "https://launchpad.net/bzr/2.7/2.7.0/+download/bzr-2.7.0.tar.gz"
  sha256 "0d451227b705a0dd21d8408353fe7e44d3a5069e6c4c26e5f146f1314b8fdab3"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a79b402d419cfb7d7f2a5e79962030f4ac53baf07c5606246b9c5a72de4ee8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "294ae3a44a6579e80834a4e4b2afa3fd8b20c96f60a0d4fa3df714e89fa79c90"
    sha256 cellar: :any_skip_relocation, monterey:       "4408a6ec92f0bda797ae91db281878f36db75c7fdcf500c2f298018873fd7150"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1d2989bccb0bd569ec1ca4425399cbd85a14564265cf8b79db45d575da7f8c1"
    sha256 cellar: :any_skip_relocation, catalina:       "c9ab575e1e27fe8e550690c760464c37890ca5c1fa8ea111c74d0172d0fa1453"
    sha256 cellar: :any_skip_relocation, mojave:         "32411a9e28eb27b3637bc915150581524897a18ba223313e5bc2f776785aae9b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "cb1c0c8b5f19abef4043195d8cbd19f363a78581596de1ddcc763621964335b3"
  end

  disable! date: "2022-10-18", because: "is not supported. Check out `breezy` instead"

  depends_on :macos # Due to Python 2

  conflicts_with "breezy", because: "both install `bzr` binaries"

  # CVE-2017-14176
  # https://bugs.launchpad.net/brz/+bug/1710979
  patch do
    url "https://deb.debian.org/debian/pool/main/b/bzr/bzr_2.7.0+bzr6622-15.debian.tar.xz"
    sha256 "d2198b93059cc9d37c551f7bfda19a199c18f4c9c6104a8c40ccd6d0c65e6fd3"
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

    (bin/"bzr").write_env_script(libexec/"bzr", BZR_PLUGIN_PATH: "+user:#{HOMEBREW_PREFIX}/share/bazaar/plugins")
  end

  def caveats
    <<~EOS
      This software is no longer maintained. Try `breezy` instead:
        brew install breezy
    EOS
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
