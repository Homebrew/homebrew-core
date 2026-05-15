class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt31000stable.tar.gz"
  version "3.100.0"
  sha256 "b9cbf2663b0807667b17139e8cb85acbf98bf9ce01b0e4b9d5fea1de76e8e0f5"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d80f1bdf26e9d03d4c9456a57900b2856830af60b7295b672f76e0889a326de2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918da6471f4c80baebd233f569b95e1f97fe54fb55728b22a2f0ef64dd379760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87435ef712568e79ad20a54417d0382a11aaaa56c77fc8a5b97e27e74ecc8afd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eaae56c128da5173bd6e65d81e7f9fef74a2fc1de8afd5e3c6325c155234ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "770ae52c7f6fc31498130729449e68bdbe8707b2b3e81549453decf2e8ffd4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc52a9bdddd9130395a20f133026a5c22a9fc4f2c886989198360fac7bc54faf"
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
