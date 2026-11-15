class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.4.0/apache-activemq-6.4.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.4.0/apache-activemq-6.4.0-bin.tar.gz"
  sha256 "75d0c6cbf32a9381b875e70e59f4ce855bf80948fa0520f8a7c4ae38c31ea6af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b7a8d338912b292ecd0f91d70e87270070b7d4dc7f6eb72e81328017c24b3cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15fb88356942e7a62d14a0d608bb3461082e2a05220f194873f54d05e8de17de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a0a4578add367a68f78ed243cb597759706e4791dcb7bca513c4294cfff9e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78980158e2a27b7dc96f0515a738d298dd36e4ef8d6cb69e09a1f04acff6b360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "765dbf91fe271f7a65fbccb53c1759f0369668863cf7c656642793c3dd35b2e2"
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
