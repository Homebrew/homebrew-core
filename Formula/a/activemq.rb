class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.3.1/apache-activemq-6.3.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.3.1/apache-activemq-6.3.1-bin.tar.gz"
  sha256 "25350d3f9462e4297aeb1d1196443995e68e1fb7707a250fa2b7619db478daba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "426e35044b44333f676afb31a0619a476405c72a20dfd63692e65dcbac8f9649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7902753974cab49398ee31087140e10f27a49da29190264e215cfef4b4dfbce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d2ae64dd33802f511d0dbbf8aaedbdbebf45a47e0d5c80c310f74d6b207df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "23f0d337973e95b4020c8a78393150a0456d833b5fac7b1fe3f84427086c3abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a153a75bf9c5ba57911b1afbde194bf74be9faee6b6d502afa4dd7d88890f32a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e6a42bfe8d673226c5c7a758bf9bda8a2b36d1c62e1aed67bf3f98a7c6de099"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk"

  deny_network_access!

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

    wrapper = formula_opt_libexec("java-service-wrapper")
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
