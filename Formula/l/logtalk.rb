class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt31010stable.tar.gz"
  version "3.101.0"
  sha256 "72a2bf4c9950751c6b9708e551962db593b46ad29dec53ab27b6871e917fd47b"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cefd9ad94e7416ed55da199b957f1a0acc3a0f1bef70cd76214c2d2acb50c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901044885db93980f69ee7a841eac73badfd9b5bd6c73acba05a3a37b6daa5ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb91d31aa8cab4025422b16d0d3a8db111ac101feb05826eaa9a2f4f619e7803"
    sha256 cellar: :any_skip_relocation, sonoma:        "0396056130077b95bb92816a72bc413171444ef1de977da362602b6d3be8e27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a4f312d28404bfaf3c8c7bb3535db381c975079105297b2aa4c224cf68cf44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6dc04ceaa7c698cc9c8b8a9ea27f3197aecebdafecfe87990b4600b5855079a"
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
