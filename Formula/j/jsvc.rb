class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.5.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.5.0-src.tar.gz"
  sha256 "ada59936c74523a2f0f3e29d5bbe08de955d09efd6abd85128f3c42eadffca6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad664c12aa7e57fb0bb4eb290de077faa281b3a0bcd6b9503375d8182bdf5a2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "437f1ad5a3997a3634b3774ffd4cfdaeae9584ff89674c217268ef4ec1b55b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b218d55e0cc96e32b98bbd39b4bd178997c3ab3605df9e1fe133b1354f35b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "835040ba9dbd2decc5ed469a2bf9c9c98f3180d9e901ba3696343c925b4ffa81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16d3980087485bb1be713bfaa9688eb06e317f41d2c03699e4f0fc0fe7232763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0daef3d24d32b9034b2323392abc0e031500263079ddd7263cde2938687a9419"
  end

  depends_on "openjdk@21"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      # https://github.com/Homebrew/homebrew-core/pull/168294#issuecomment-2104388230
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

      system "./configure", "--with-java=#{Formula["openjdk@21"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env("21")
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
