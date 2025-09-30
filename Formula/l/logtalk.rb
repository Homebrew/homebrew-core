class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3940stable.tar.gz"
  version "3.94.0"
  sha256 "36f68dfbbc617cbf0bd370b15b324d308f021e211009f8c45133224c2ca9df09"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8d1adc6b8dad0f9e778bbec53705202dea06b84105c501ad53979bc2140cd29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd93dd4b4909880a626984dc066488f06631513122817788393b28fb1ef56285"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31dcccd20391fb8b1e86f534282814ea21cff1c571918b2eb6d54965e4ff2096"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a5cac968da54a265574a667ace865a60e33c55d49da444518665b2e83e42c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af84c65140adb8dab8da4c42404930d267c79654f5b811f83383ed22ca3048a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47774866ef659c9badf6049293a14375920d8247e22ac80c122736ef0cf88b77"
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
