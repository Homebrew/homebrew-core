class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3920stable.tar.gz"
  version "3.92.0"
  sha256 "029eca6bc6296677a9c2882937a8648f7cf858fd432f1ddbfc1f4d219555cb77"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d052f91d6a6bb33233ce1850afe0f8ad1fdd2dbee8951932655713ed03fc9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5ae1ac34a6d3b1419a29b78c9c49e44bf54cb3ec31073783a4d037ba61416f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63c7a9568efaf72ee309017ff0479295e739d549b00f438e96fa0404ebc074dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dec7000f60c8965fb25b4a3472ff632cd38bda1ba31dd6f572df49f50d18719"
    sha256 cellar: :any_skip_relocation, ventura:       "4a97c7ca1fd5d790d0c3b6f6cd8ad389003581d4fb6d49684c6d15b42036b3ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd29a5aa5b6b3c8db90fe94958b5d7dee6941408bafa55485b4c47a51f33411f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fe260233f5ee28127a4307c65b08b065ac014713b7919d446a73f8d0924d025"
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
