class Bazaar < Formula
  desc "Friendly powerful distributed version control system"
  homepage "https://bazaar.canonical.com/"
  url "https://launchpad.net/bzr/2.7/2.7.0/+download/bzr-2.7.0.tar.gz"
  sha256 "0d451227b705a0dd21d8408353fe7e44d3a5069e6c4c26e5f146f1314b8fdab3"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "184ea0c9b6dd3cb287257070325188828c669ecdf5f231b477182e9d616357cc" => :high_sierra
    sha256 "506f81fddaadfb97bf1e923e16374d3bc6fba066e94d6cf4b0feadbc7bcf91a7" => :sierra
    sha256 "75e4a4aa57887371b783839667da3a142805c60f13197d599f6c8ef95c104707" => :el_capitan
    sha256 "7919335ffdd76bd54a3b58da3e7d9499f8bc6dd895b1d117390bb19ceaf08818" => :yosemite
    sha256 "51a058a4ff6b070a62ce30d01a673bba74d65d4eab6a13a9d53696f24cceb80d" => :mavericks
  end

  # CVE-2017-14176
  # https://bugs.launchpad.net/brz/+bug/1710979
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/bzr/bzr_2.7.0+bzr6622-9.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/b/bzr/bzr_2.7.0+bzr6622-9.debian.tar.xz"
    sha256 "fef6f9a8c3e2f227bf42d0f2f93ea60251a60cb420f7b561d97f0eb685f6ecb6"
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
