class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.6.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.6.1-src.tar.gz"
  sha256 "15ea9386b760ba74f2926fbc0a6853c1088a4c0dd5c46d0d1866f9ff091a6364"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfb95067226cb4e693882972be5e517fa75fa82eb1d5593a64ac849b2661291a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea93d34c2841c28e484ee9a9c12ab8ed6512c8ce1aca82f1d6436d7edb64de8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "096291cdc0d0335ed80a5b15249f975282f535d72cef0a3e8f49a16a5c6ed826"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec4e8730bd147c2dea34d9f64774ca9fbb65ec70f1e70197e78b4f5ff9e86f0c"
    sha256 cellar: :any,                 arm64_linux:   "215c20075db1e372de2e4a8e842f57b3688304b1dfb557ebe74d53831e7bca8b"
    sha256 cellar: :any,                 x86_64_linux:  "8d7c506feafa56783dab019856bcf495f3ee5836791e8a6eae748ce155c33764"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      # https://github.com/Homebrew/homebrew-core/pull/168294#issuecomment-2104388230
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", "--with-java=#{formula_opt_prefix("openjdk")}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
