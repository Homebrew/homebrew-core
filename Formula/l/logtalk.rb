class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3980stable.tar.gz"
  version "3.98.0"
  sha256 "6ede03c1c8397947ebf567636ab4868787b2a58582c81d015884db135f7896a0"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50aa92bf60fd3556eb9046df3c1ea4789c16bde6df8391490cd09b9dd52efc7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2692ebd45dd68b776594a3c983428f422c124351e29a45ff5e1405346826e1ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9020e19067207027a8dafce033a12068bf8a9ab5e0c68f6aee373402cacfd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f14fe024b95a7c4ba7a07be8abc9bbb92bbc18ace25f6ea715ce98b9dcaf2fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d1b05f0604a36d04f322d00a4e463c6f0d19ac783c5633c6aa04d8b9844a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a65c968c01b138fafc1266ff782ae9acdb7bc87c4569b09e283800a0d4c54d"
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
