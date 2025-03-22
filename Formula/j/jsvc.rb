class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.4.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.4.1-src.tar.gz"
  sha256 "c8fb223456ea6df0c61f3c65afb4a8f2c66ddfde4100160427b8ce98b1215131"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ae96a8f546da4a7badc391467ad2807a629ecb76bd3ff649de0f2d406d85ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f8618c8cbd2f9d20e02bf7e7a241375a41d20816ee2859b8a73fc413070595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f86b48615d15ad2559ed1f46207bbf801be90db8e1402fc98a10670e38923db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4be28d772d108728d3ddc06017a22b8848649e86a55d53e6123aa1c4c7779fa2"
    sha256 cellar: :any_skip_relocation, ventura:       "369d45598b76c1c87b4f511095ef4b53e17364255ee1218192dcf5d79c1ac642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74d1d873adb94b9c89f94d985bd35b88e5a723544d3b8d3d790eab699f7c50d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20801baa244214c265bfb7c71e6601b44141b658851fce801e0e52de7e6a829b"
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
