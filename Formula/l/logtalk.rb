class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3990stable.tar.gz"
  version "3.99.0"
  sha256 "d303bd04bf73a39ae2a415cfd3bf545c2a90139cf8fd53ea614eeae57b8e72e4"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e511fc356de970ddeb1b32b833d5defcd0d84ba5556bd90080d67e64b20226dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7ed6c2b425afa879d376aaed2996c6820959521941516b2632823842c0d9e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45423f3761d3cfd4bd17f0e704dbad09a69c6aa98de7e12ef7172392659be7af"
    sha256 cellar: :any_skip_relocation, sonoma:        "06dd5cbb97b26cff7e682a90166c93560ee645d4f3e02350782c6475e3a2699f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f34058db064fd2a8fde05172cc5992b6b6be309fdf4a9200e4916fb3d6f41ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0754fdc56312cacc60ab414cdf5e5bd2047ac8d39e38e19de23818f63346fd1"
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
