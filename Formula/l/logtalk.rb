class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3911stable.tar.gz"
  version "3.91.1"
  sha256 "fcebf7696a2dfc102f1f1b08a1a69c15fdcd020e8df17cccec0f1c08c97b4e58"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32146ca005f05687b4920d0b85838c0dd7f5e0446092ba3e568400d38e8dc135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96722265d944e0f6399ed816d6ac98a17340a00a625ee68897b51b9a09ea727b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "879202363a40674bc711921069c5d5669940cb2ae629e9414f47b06aa6f85855"
    sha256 cellar: :any_skip_relocation, sonoma:        "55008a9b41f8de8d7285ad61c088c951d197d52df7a61afc1f71f789811b4278"
    sha256 cellar: :any_skip_relocation, ventura:       "83018b7d88da453f590c69fa50ee27eca5004c064e752e717f40ba8142497888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "183f2918f6db041c3d39c7c6a883f79f622ced9120c05cbe58d5bfb569426a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aebac4c6f05b1823e51201318d7fb2f27d982ccc1c1593d833ea28f6382b900"
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
