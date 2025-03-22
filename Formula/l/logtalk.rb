class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3891stable.tar.gz"
  version "3.89.1"
  sha256 "6ebca8de86b6589cd7cceede6200049c4bb267e8c563702d58bd5c56c9944f12"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f09bd805c653a73a144ab9be9f01450d819e580088be20b885522f75ee0e46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d19e0b16d9d7862d8a389a277d1c1bbe079764c0f747219a6c9c88c6ce167a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1023d16c0b2132746b0fc01c9e7d55667ffb70b0d965672515d5f35a384ca2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7db918dd58eb18cdb664f9c1d7faa81f2530bc7c3165294591c901888aec60"
    sha256 cellar: :any_skip_relocation, ventura:       "615de0b1780e08654babf7278b844d53422a493dd688c65abacb442b42df6ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25bc242870fda348ff5c09328a924085836064a7cd392a2ab3d3f49fda7dae52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b726616b45c37b3eb1a760f452372a1654c69c8f1b3149992d770fef95d7cb1a"
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
