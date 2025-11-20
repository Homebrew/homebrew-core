class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.0/apache-activemq-6.2.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.0/apache-activemq-6.2.0-bin.tar.gz"
  sha256 "277bbfa792d140f809bd02a6e3fd53819554b857ad5a522d716a14a67f63c698"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f10b5c1e36110628b26befb976ec49221f48215d52cc39e6d08b74f1f758c01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce298d6c514d6b0963d2946371ae6ba4960dd883df5854e16166b6baeabdbe1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93c9b86a40ff627cd509924050a46a9f83d7bc850c0fe74b7fb3a5623275e0ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "03df5911d4c8b283181117455e626b8a40d3d6a6e46a48d35d38daedef620150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e488b4bd5f2fbe72dcaf32716336f3342abfa87c8d0a680c6e71492af2a8db97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6216f905a46feb4554eb7d8b9b5d8dcda32f2050eab7e418b34a7a4efd4caa6"
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
