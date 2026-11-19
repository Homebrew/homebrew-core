class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt31030stable.tar.gz"
  version "3.103.0"
  sha256 "c461388e4d5715dbceadf570b3ad48efc71998c20f35a4b4e2f3cd22b5f020c7"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48cf25d967c9f9847f2e6795c144af7c20768f8802a6034cc0445ad78e2a4baf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78f5d49c63ce66b73956214d5cf11cd5f0b767cd45ec751471be2473afd2489d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0c931d9d7975078d4e8d55c7481d4c8725d19ed29dba76d1c9ce2ee01dbe68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "518bd8bd3149f3fba00dd376aebf71d6700965aa90528ff11e676f43744df475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "680611ec0e7fdafcb31d565583ef0b368c856fe565b2070b209d82ea95566aa8"
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
