class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/20220122.tar.gz"
  sha256 "720a06ff8dcc12686a5176e8a4c74b1295753df816e38468a6cf077562d54042"
  # https://fedoraproject.org/wiki/Licensing:MIT?rd=Licensing/MIT#Standard_ML_of_New_Jersey_Variant
  license "MIT"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "932275dcd4d64809bbae65d3819aa6b0fe643ac2a3ec16b3d1babacab13168ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65041e32f93bb2c9fb34499a142599d1197812e746a97538dd6ea0d0b952c26d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2d1a70b2bbb181d8d3a4372600c89f066085bd622af35ba5286d066d79d78fa"
    sha256 cellar: :any_skip_relocation, ventura:        "91768e0238cfcf0de76ad9c1ea299455e652f66eef72349d7c63ea3626f9a841"
    sha256 cellar: :any_skip_relocation, monterey:       "36440051d67edfd36eda51c6e37faac85b8d4cfbdd650160f66445b043686e43"
    sha256 cellar: :any_skip_relocation, big_sur:        "50e132ca2ee5ccd0e5eb143ae3184f9d787bee4a1906b5465bcc2fdcee18626d"
    sha256 cellar: :any_skip_relocation, catalina:       "b8169a72b8a1c318c426837f59044fc9c67f1b31d4029bb0e9f4f67d8d4c8602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b875a21cdac385ac38de2474281d539e3e668b8eb2bb94043aa41c468d637df5"
  end

  uses_from_macos "bison"

  conflicts_with "gawk", because: "both install an `awk` executable"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
