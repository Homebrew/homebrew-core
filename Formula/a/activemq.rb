class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.4/apache-activemq-6.2.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.4/apache-activemq-6.2.4-bin.tar.gz"
  sha256 "fe3bf23bc70343aeba8bc279dd25cf4b95b2066379199c0ae9355a0f15f12613"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "301a724cef18c2a475641f35293cfdc7cc19ca526811e2c1c1f457d9acbf5afa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc60984039b27909307520b6f4d3c0968bcdd026366eb688cc6a1f5fd06622d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3db6614705e4946f9faefe2fd0a4dd297a6966fc0de8b6e3c06980aa7c23f6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b61c3627c31601411807419ddc7e521560354e213aa85260adda050933294c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0b81bbccfcead36a8bcfe5d3a166c0b1a9c803da803980e5f04bd49a4ba12b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed33653f2273149903a792702865a015a7d447f3d7d20e2fac4f6ea304430d07"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    if OS.mac?
      wrapper_dir = "macosx"
    else
      # https://github.com/apache/activemq/blob/main/assembly/src/release/bin/linux-x86-64/activemq#L176-L183
      arch = Hardware::CPU.intel? ? "x86" : Utils.safe_popen_read("uname", "-p").downcase.strip
      wrapper_dir = "#{OS.kernel_name.downcase}-#{arch}-#{Hardware::CPU.bits}"
      odie "Remove workaround for arm64 linux!" unless buildpath.glob("bin/linux-{arm,aarch}*").empty?
      mv "bin/linux-x86-64", "bin/#{wrapper_dir}" unless Hardware::CPU.intel?
    end

    useless = OS.mac? ? "linux" : "macosx"
    rm_r buildpath.glob("bin/#{useless}*")
    rm buildpath.glob("bin/#{wrapper_dir}/{wrapper,libwrapper.{so,jnilib}}")

    libexec.install buildpath.children
    (bin/"activemq").write_env_script libexec/"bin/activemq", Language::Java.overridable_java_home_env

    wrapper = Formula["java-service-wrapper"].opt_libexec
    wrapper_dir = libexec/"bin"/wrapper_dir
    ln_sf wrapper/"bin/wrapper", wrapper_dir/"wrapper"
    libext = OS.mac? ? "jnilib" : "so"
    ln_sf wrapper/"lib/libwrapper.#{libext}", wrapper_dir/"libwrapper.#{libext}"
    ln_sf wrapper/"lib/wrapper.jar", wrapper_dir/"wrapper.jar"
  end

  service do
    run [opt_bin/"activemq", "console"]
    working_dir opt_libexec
  end

  test do
    system bin/"activemq", "browse", "-h"
  end
end
