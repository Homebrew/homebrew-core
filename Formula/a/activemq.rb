class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.5/apache-activemq-6.2.5-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.5/apache-activemq-6.2.5-bin.tar.gz"
  sha256 "b00212eb498f66535c554c3310dbe97cac1659c2c553c06d4b1cee13996d54b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "271419a8fed69f97224ce01be527c863d1fc42efe05d45145857fb064c1b2f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3283ead3d1a405ef54a7708614e1533e218dd0279728f1a04ef8954b9e6ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8499eb5490f401e73577a09d2e62b7408bf8ed0a4c1c1e5d1057a7b06fdd08"
    sha256 cellar: :any_skip_relocation, sonoma:        "086ae05f72548edf77adb366849e4e7808d467a110525d2400aae041cff00114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "356a97067fd3d729ec0940dab018ff52c8bf7b706d2eb5fdb06a17ff6e4f1703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a96b921b7a4784b3ebc3b5fd43705f55d5f66e64e4c059015851a85be45bc2a"
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
