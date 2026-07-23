class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.7/apache-activemq-6.2.7-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.7/apache-activemq-6.2.7-bin.tar.gz"
  sha256 "7bb616f47e94c3bcd17589712ba647e893b049010c104c780fc227e83fed09ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8c7d2f33148f0a74b5c949632babfbfcaa69d37d2b93cdf75242c19218dd7b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e13cde72a651bfd6af5c3352365aff6e0a5d28c0084cb279423209539a68d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8782bcd758619ebd9a0310a01feeecd5af9245938d3662963b2daf785a3d1fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "88164f900bb88c552f689de6c7c51afd5561287cfa5c0454f8db621b14fd1de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e84bb4028c9dd3746fc3859250bc08926db9057928bec8fdcf9835205b03b249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8250a561cbcad421848957b42b39f6e1d9a1e668b19b71a64b6d1ba954f2fc77"
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
