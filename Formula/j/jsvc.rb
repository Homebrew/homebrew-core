class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.5.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.5.1-src.tar.gz"
  sha256 "48f9c4e63af0d73032eef2331ab8e9d3e0784b008ba2e7cb79fdd751c5202ba6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f249e20ad4469f4ead87053e4b77bf2dd32a0712bb0e6f0b8885a4a8c89ad522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c9d7698febe85919a990afbeb5b5c83ef68ae746bfc2dd1e82ba3a20d2d02a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4383b343f7eabf185019e7482033ca39569844de405155330d39b032f69043"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f297011a334d4f40bd35135383f3063b2c4fc8fb73083e3a36c88c3d77ab1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4086828985d6a77620eebdfc4008bfdac0d9eb6224e128f6db5a3f7eac252d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f72edc6d6177e9f50e67fdb4b3a5ba38fd324137c5c904a5a95f4f14ec3ca232"
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
