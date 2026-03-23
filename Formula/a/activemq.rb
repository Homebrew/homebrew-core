class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.1/apache-activemq-6.2.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.1/apache-activemq-6.2.1-bin.tar.gz"
  sha256 "bc16d030bc53ca4240651c65ec13dfa272c737c90fc7e34549ade0c0b670770d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c89cfda34ec492192c31a03909d266871981084dd80ce489ea71b56c0b30d43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5868f8fa9d26e6f5f53c0e4a3f43b9aee3881d891dace3e1573a6847d30a79ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f630669c734bd53440921d683721321aebfaffbd934c7c569b52178601001d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db33cd8a922c16584992cdf7f57b8eda72d48c3cd3dc6c5fd2e41b495ec0829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9825132a548d060ee5baa2140cbfc31e186b6754d2d5fbc1f7eb875760ec0c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0dbd7ca3f64e8a6f45a58831989abc676c67cbeebda32ad6587cd9687d6246"
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
