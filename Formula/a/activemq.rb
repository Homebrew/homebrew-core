class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.3.2/apache-activemq-6.3.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.3.2/apache-activemq-6.3.2-bin.tar.gz"
  sha256 "543e9ca8a234d118a8c195d802a110994a59b7973d75ae0a7ccd47dc2cc2c5c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa03e3a0052277cd168912cd2c9ea4c20bf7bd58c8ae77f4f1f9725eaf36bb01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e38bee98b6462d4486a658c58d862d8f7456b96f85b2a1bbfd56a79a8bf08aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e95b30811c77de2c1086c394f70633c8689820bd9f12f9234a276ba950b0d6e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "58c7d2008bdd317da52d64eff14ff500d916d32aab0acf9ad8a819cb0883430e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dceb9ae13e226572e487d6554bbe18ece88715fa7c1e440d6bf9e22a8278b08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a4014a26d71f199a28baecc305951cc092c135d74c48906006cfb97ad13f3586"
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
