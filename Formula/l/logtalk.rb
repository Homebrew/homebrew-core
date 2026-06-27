class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt31001stable.tar.gz"
  version "3.100.1"
  sha256 "29a37cdd777825f2e34cfa7f849335943817a8e2b5444ebc21e513bc84d83603"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "259ac8dc660acdb9505bd7871dd18bc3fc04cf854f821fb4302d8fd2e0f02a37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b9b7ffb1a10b5df3fa4df603f37d0e3a229f91e3f6a65a58582a142bc0735e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c55d5db70e45e291dc127ec32944f8dfc3cce457cc235779899607788bc1edf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c99520b8a906f9a2af9dfc3f71078fb34b959b45f01074bdf95fcc9f30d98971"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29813fe926e776997a8a3607d4cc5de202806d4f1044a2b1d217266e93449d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa52626e9c11c3c7fa82c4839cf28e76e88a8107cd68bc04b2285de5373b097"
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
