class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3960stable.tar.gz"
  version "3.96.0"
  sha256 "71c7dd7e6dfc223b4d488b2ff80e2d6090e027e7cbcc04885d43e8af686d6299"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09dceb6066096756e510f9ff5292a3a254dfd7869fe3f4c00bf03be980283c7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0efc88edb608423d0f744ff0fa8edeb2ac9f5655e356b819c4572b658c99f933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25abd26659147d7d9d8160f3f11143cb00521866788cebb670db04fb18ddfacb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bc4f58d0c10fcda0f94e42b3799452056876e4494ce777404bdf757519b4917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5decff954dded85a057e62bdf49f9791e2b2afb5d1fb4789ee3155b8b2ff02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e5c3cf7545a6540957413d37310fbb5cb08786268ec2845ee2dd9bc484c16a"
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
