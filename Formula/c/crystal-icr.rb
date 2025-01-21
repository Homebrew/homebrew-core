class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "39cdaf2148c5f0a4bd256139cda76e88414ff6f88546030ff3897f879f066e13"
    sha256 arm64_sonoma:   "8dced8d90ae05f60022cad48273fe5dedbdb270c676f1f814bee7600f8b6451b"
    sha256 arm64_ventura:  "a541b6b20507872a2b45a244c6842a1509553d178a596e1d0d19a799f1ab3e56"
    sha256 arm64_monterey: "3944027c41242611a14ec6226bc7eaf63e6275483df6b6820115d39c27ca76f2"
    sha256 sonoma:         "1c5da529830479e589129eb4bbe877aca87e67d1855a5ee4019917c98b88d688"
    sha256 ventura:        "32a63575106616c8855062c261bbd3c02b07fd0ee30dd3aaac50226b375a37c3"
    sha256 monterey:       "b134f903e53188ad2d8c2a891441c86a48467e4134e774bec72a04ff74085a58"
    sha256 x86_64_linux:   "a65683caabc652020da6d97ce2d2a8acc7552af5c75c6afce6010d9c4b0ce156"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    llvm = Formula["llvm"]
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
