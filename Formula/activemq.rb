class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.17.0/apache-activemq-5.17.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.17.0/apache-activemq-5.17.0-bin.tar.gz"
  sha256 "eb06abd7f45efad42f4f56b671fee7dff4ccac387e0765b1d256e19bea66f897"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f1c72e8572862e11826911990bc44ba6b0d7294e39ad934737ddb63b45c43c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffe6d6d38a0dc48f22ba38a377048f113e1b5dafa6379010bb985da4e0301bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "7885cc7e399e9211f663ca139acb7610df0db31ee77575260b5da8044cf6ce55"
    sha256 cellar: :any_skip_relocation, big_sur:        "46c9cf6d47efdf9f42ce726b0161eafb1db0203cdbb3ebee853b1fced29d2f38"
    sha256 cellar: :any_skip_relocation, catalina:       "2a9330a54eacfa0b1d3168c0c37c48015386a75ee3b6c7035dec1ed51cbd5255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b5042c40e73532a7f2e7e3dcf8e97560a0910aba422e133fe1a21a74d52eea"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    useless = OS.mac? ? "linux" : "{macosx,linux-x86-32}"
    buildpath.glob("bin/#{useless}*").map(&:rmtree)

    libexec.install buildpath.children
    wrapper_dir = OS.mac? ? "macosx" : "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}".tr("_", "-")
    libexec.glob("bin/#{wrapper_dir}/{wrapper,libwrapper.{so,jnilib}}").map(&:unlink)
    (bin/"activemq").write_env_script libexec/"bin/activemq", Language::Java.overridable_java_home_env

    wrapper = Formula["java-service-wrapper"].opt_libexec
    wrapper_dir = libexec/"bin"/wrapper_dir
    ln_sf wrapper/"bin/wrapper", wrapper_dir/"wrapper"
    libext = OS.mac? ? "jnilib" : "so"
    ln_sf wrapper/"lib/libwrapper.#{libext}", wrapper_dir/"libwrapper.#{libext}"
    ln_sf wrapper/"lib/wrapper.jar", wrapper_dir/"wrapper.jar"
  end

  service do
    run [opt_bin/"activemq", "start"]
    working_dir opt_libexec
  end

  test do
    system "#{bin}/activemq", "browse", "-h"
  end
end
