class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3971stable.tar.gz"
  version "3.97.1"
  sha256 "510dc08f2018f3f464f15a056506ab5229870cc906e86909de626922bf7aec75"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "773dbd7b3191a7233258433467400e930bf65cd78e2ec8a9aa91f35f8279d67c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e22108ad16e3ff38f9eb8335b51f3d0a33f929fddd2a73aae30fe5fd057290e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48de8441e7413fe50cb2804a447b412df2927ddc48ad1e85e0ef986c658a32b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aed5411beb93b91672d1607cf3c12209b7e8ab98239038e819c1e98ee2261f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38ef230b3bcd41e12a3a674278fd68258f82dae52ecb4b924e3e791f9ed224be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fea21ce604feb1abf6299b92fad0ae03d1d28952b8ecddacc742c6894aa73db"
  end

  depends_on "gnu-prolog"

  def install
    system "./scripts/install.sh", "-p", prefix

    # Resolve relative symlinks for env script
    bin.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      f.unlink
      ln_s realpath, f
    end
    bin.env_script_all_files libexec/"bin", LOGTALKHOME: HOMEBREW_PREFIX/"share/logtalk",
                                            LOGTALKUSER: "${LOGTALKUSER:-$HOME/logtalk}"
  end

  def caveats
    <<~EOS
      Logtalk has been configured with the following environment variables:
        LOGTALKHOME=#{HOMEBREW_PREFIX}/share/logtalk
        LOGTALKUSER=$HOME/logtalk
    EOS
  end

  test do
    output = pipe_output("#{bin}/gplgt 2>&1", "logtalk_load(hello_world(loader)).")
    assert_match "Hello World!", output
    refute_match "LOGTALKUSER should be defined first", output
  end
end
