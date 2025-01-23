class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3870stable.tar.gz"
  version "3.87.0"
  sha256 "3d4d832370ea9ea841fc193656f5e7d6415c877c94e48322aeb8ded1beacf9d2"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db330cea0fcb60e9c6a29334b4fbe5a028f891c133dd4af2b68899030d5b6258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f866e546b7cbc5833cf0cfc6673011e4eca91427d7aed0e64310becede1407a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b345bbad93b6b75f972d054a15332ac95018532b6e05bf0e44863300d1deba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26eeb16def34edb548828c685feee725758c5d88ddab27ae7e073a16163d186"
    sha256 cellar: :any_skip_relocation, ventura:       "48a193cf6843352ea37f8587935e1a346dc2014012edcb533bdaee6fc446f17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc64a46e5c0cac5430a6643edc53a3e532cf8ba9d7020b7468a00f8f093c615f"
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
