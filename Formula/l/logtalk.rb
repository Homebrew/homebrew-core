class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt31020stable.tar.gz"
  version "3.102.0"
  sha256 "269ce4b1b5aa5ca59940a7a65e0caf10a589a44dd2ec1cc3711f8c48e4712c91"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e90229713060045c5c902b09bad9c4ad0e97afe279f6548ae2167ca14673049"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f781729c034f5a8111d9a0749cf978ec6532a38f9d2adc60efd50192684197e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06c9cc894ff10b8b67c074f2e0115f96f678d807452f222294fb3c2cfc61efbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15c683cf73004349e07196b2e87b27ec39d02d203ef53d046dcf3b60da0711c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "549a7c3564e98e0e9dabd1136975742d931a79fa18a943ad06b2d7234e4e5deb"
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
