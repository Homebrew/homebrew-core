class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.2.6/apache-activemq-6.2.6-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.2.6/apache-activemq-6.2.6-bin.tar.gz"
  sha256 "91897204f6bad85af5fc0d984704a3b02940f0ff276a33c35af0dc160644a1a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "991522473cb8eeb56613cb76aa010dae7d47e0314eb2d5ad4dbff90340721c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2223a7b6da65750854653dc5309d8a8c456495b74e7833018fc81a50a818248a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6c5bfe2bc9b281a7170e598df64e6d705c42e037a8a92c0951055ff7691b2b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "09ca0869f3b25e2f78895396e51f6628718a529b4891a6cb1aba9c4e846408fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d96efe61fb9975c0092601e239a6b7c2e3af6cde56bd5da656a90b02832133b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17d7a3446b09661567fc8f10ba800a1b091c5941343d47eba0a58bdac09803fc"
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
