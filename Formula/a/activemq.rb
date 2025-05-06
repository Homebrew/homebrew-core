class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.6/apache-activemq-6.1.6-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.6/apache-activemq-6.1.6-bin.tar.gz"
  sha256 "32ac692da486d7e82819586dd3c5661bbbb5d6d42599832a494797058608f0a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e821df7e834c39b56b15ed0cb9f98bfc472720fdad3cdbbe20f80f966964707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c21bd6e87749ad70246e46c12e8773feeeacf4ea119a55ebcc6e098f887adf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aea4834f9c0175822102d8e8c4029f3af0345a536f66e67234e3e997077fd32"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a1d7e1b0ecb2f26c6eed93b479b18d20e4a9471d200ccdad309770577431cff"
    sha256 cellar: :any_skip_relocation, ventura:       "806867bc7cbff9079f42e885d8765b4869ed257ea9f066d857c2303c4b910430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b95a03e459a9190375bd22a7806fac2372aa1c7893a61c38cb6acb91e8bf3c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9ab276b52229846bc56192b0fd45ad573e57738818b880c3a9149eedfd306c"
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
