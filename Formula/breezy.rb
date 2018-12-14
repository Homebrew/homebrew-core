class Breezy < Formula
  desc "Breezy is a version control system implemented in Python with multi-format support and an emphasis on hackability."
  homepage "https://www.breezy-vcs.org"
  url "https://launchpad.net/brz/3.0/3.0a2/+download/breezy-3.0a2.tar.gz"
  sha256 "c7805e6fd61f3046ca5b31311bc31e647e5a40b11ded85b901488d439fa9f434"
  revision 1

  bottle do
    cellar :any_skip_relocation
  end

  def install
    ENV.deparallelize # Builds aren't parallel-safe

    # Make and install man page first
    system "make", "man1/brz.1"
    man1.install "man1/brz.1"

    # Put system Python first in path
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin"

    system "make"
    inreplace "brz", "#! /usr/bin/env python", "#!/usr/bin/python"

    libexec.install "brz", "breezy"
    (bin/"brz").write_env_script(libexec/"brz", :BRZ_PLUGIN_PATH => "+user:#{HOMEBREW_PREFIX}/share/breezy/plugins")
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
