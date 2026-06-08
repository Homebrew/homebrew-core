class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.6.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.6.0-src.tar.gz"
  sha256 "32da7dd4bbbcbcfa96d0aa7edc99377f7a0c2b9beb40b5516e591af3e11b4231"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f004c11e26f1f66ccb604b916dd3d714efd6cbbd808e5780c73df571c7591bcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "053bf48b48cc247fd9ac60c82f1f0ff8d7d08afcb1cbad25764baa31842e530a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf56af66872f2c702a83d478577ed9d9c9f56e6b082eb9ab709a122bf82cd097"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f68dbffcdfc75d1ac47a79a49536ae1355c454d49e8306119b30591bb20107f"
    sha256 cellar: :any,                 arm64_linux:   "40d37209e5bbeae4f6870bd66a2428e928b6885f03aca55fbcf6f6621a541b37"
    sha256 cellar: :any,                 x86_64_linux:  "e191f404809b4d0c5d0cbfed4318a88c872785cf0644684d2f723a987a1e673d"
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
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
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
