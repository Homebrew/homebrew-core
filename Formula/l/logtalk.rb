class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3880stable.tar.gz"
  version "3.88.0"
  sha256 "00f3449aa96772bdac2ab21e8c7b56b52af3ee28efbf33636a50f51a49e6c6d5"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9db41154301620255f02fe620cf45464a5c884914528926d39cd6ae084b384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e86cded21155b5e28e90672d4176cd0f2437e2c16896de0cee6246c8b81fe01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "783b96afcbc77220c93beb7a26a55316d5fa87ff495d9518b48d074c0d35f708"
    sha256 cellar: :any_skip_relocation, sonoma:        "05671bee29c75c21676b891fed53f7dc5da54abee97cb944492f2da36468d16c"
    sha256 cellar: :any_skip_relocation, ventura:       "bb5cdd78c3b9b8ab600cf2d8629877348b256242f0954a692b98bf306463b710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61dabe18f83d61efb14d517c85c5fe81958114accb3a948997e3c6994e7561b"
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
