class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3910stable.tar.gz"
  version "3.91.0"
  sha256 "77d327b939afd1e67e69adfeb4646e5fb83408508d48d55ae36802eb653c0de8"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "524bcaf6fca716b253806b7f7363a7a4e1f8ada821aa0c9f9376c4aa4ad641e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b2a29bec9b3c16b926ce34d11616b405dc4dc49996b7191f715bf6874479fa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d51d88b7c6d68984f333e515d1ddf15a82e2df18e1eb462984b01385ce07a161"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e1c7d6e8e252f1cd1ebba96729591e92877190808b99539dcfa4be9dc42fdc6"
    sha256 cellar: :any_skip_relocation, ventura:       "1130d57fd566e833ea9bead63f230193243d5f8fed75bc0fb5b6d72434272ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "002c272990713f96f3dddd49e32343f6ffd59f817f1818715838539f44d8c85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0643203cbcb35630b89c8675580c4f090a9409c7a1fa3574b89d306cb2294a7"
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
