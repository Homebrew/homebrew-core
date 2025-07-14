class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.7/apache-activemq-6.1.7-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.7/apache-activemq-6.1.7-bin.tar.gz"
  sha256 "75cc41109a897745d44aca27358568f3cbe0cd58fc6bbff035a83c4ddf48d316"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ffcdd733fbb00cbcef28515f15aff088604215063c382a8184a143ed65ca712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dbb844e55f419657f65d86d99425b2bd29ca66b53d58a1bdb0039890da99d3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b604447aa9fe306f8ac12c35645c909590fdb9bbd4b6f9ac5274784f71120d70"
    sha256 cellar: :any_skip_relocation, sonoma:        "202874674d48d07b7c60cb66a9e9fb9779c8fd9334a04ee9982b736d0cc77547"
    sha256 cellar: :any_skip_relocation, ventura:       "167acb4010c8bdf904cbec3de9b0eb8198dc90580aa505f69a6feed3369c8d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55883938464189ad58f8bc1ec6ab23a2f4b6516fcc5e58b2a4925ccc6869b327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b96fdc871c690744d85ff3e1ec9e5ad79014496e4a4888fd479e2e695eb1827"
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
