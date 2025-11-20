class Cpulimit < Formula
  desc "CPU usage limiter"
  homepage "https://github.com/opsengine/cpulimit"
  url "https://github.com/opsengine/cpulimit/archive/refs/tags/v0.2.tar.gz"
  sha256 "64312f9ac569ddcadb615593cd002c94b76e93a0d4625d3ce1abb49e08e2c2da"
  license "GPL-2.0-or-later"
  head "https://github.com/opsengine/cpulimit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b5d88d4e5afdf6bf19d2069b78a12afb77e1f5e2ddf3b34b1cae55528a8f7bd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7eca714845ccc7a47497489a5075812b50700960acc1eb7eeefbfd5921851a76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dab4e4b11b19e8c01a57593d15ec399ab4f25b8ccdc72299e3f67092d1beaf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e94ecdb44d2b8f104510da469aaa27a879cbf41518c88315f346116203b9c944"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "993f9fe777c7feb2f2da49486e0b7febf6a6d822e64ff4f40f578ddc0f21d7f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f09919436a14d7b1598720ca832435b2500aebe0839f5055a253f52c59642a5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "611be2cfc0a3c0908bb2992fe8733f85aff851db7ea94fa9dcf2d5b20736fa43"
    sha256 cellar: :any_skip_relocation, ventura:        "e26ef5c56d8a24d533ebbe33a65dda99defac0f32504edff34358992b39fa1cb"
    sha256 cellar: :any_skip_relocation, monterey:       "71ef4e07ccd817edc04f0b60f0bdb2a4a2efa7acdb1fdbdf31216871cfe6b61c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3f394e17febb7af49a1cb35c46e33856263dc58016d959aad2d2a250aae1d7d"
    sha256 cellar: :any_skip_relocation, catalina:       "7330907348c0a181c75b069dba7ee628e8c524c9bb9510487dbfd43730173db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b4ffc1c3a63a8b4ae82354e6fed41658b2f094cbbe602a37659df8c9f10efc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e7b26fdf597d68a1f482095c11f606dc5fc6f88a27e88bf14a3e976cec0998a"
  end

  # process_group.c:64:15: error: call to undeclared function 'basename';
  # ISO C99 and later do not support implicit function declarations
  # (https://github.com/opsengine/cpulimit/pull/109)
  patch do
    url "https://github.com/opsengine/cpulimit/commit/4c1e021037550c437c7da3a276b95b5bf79e967e.patch?full_index=1"
    sha256 "0e1cda1dfad54cefd2af2d0677c76192d5db5c18f3ee73318735b5122ccf0e34"
  end

  def install
    system "make"
    bin.install "src/cpulimit"
  end

  test do
    system bin/"cpulimit", "--limit=10", "ls"
  end
end
