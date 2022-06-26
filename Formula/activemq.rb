class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.17.1/apache-activemq-5.17.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.17.1/apache-activemq-5.17.1-bin.tar.gz"
  sha256 "617ec25102cc62252e6d9b06cc496766af116c97525255bc8c4b3e75ee9e00c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d02ee913b91bbaf0e962b39cbe1c9d198bbdefa2f90590fae516209386c57cec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5cfadcbed052dcd9a09758be8f4c9a1398d5c627745714fd41c6e3a05b8e103"
    sha256 cellar: :any_skip_relocation, monterey:       "237d3c47c5bc5f7fbdecae05274d5b8255083044cffc183a0984f7f4eb3d36f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f00c6a752fa2e0d2451aa1cb39805a3cc0f159fab2cac23b56fa38c93d71f6b"
    sha256 cellar: :any_skip_relocation, catalina:       "46ce193fbf485eb163d425bac64423e6104fa77d9f6c37c74ceea226e1699594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e944a0eeb3fc6261aa2ee5ed965f01596fea2a36b477f865505cb8083037b2"
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
    run [opt_bin/"activemq", "console"]
    working_dir opt_libexec
  end

  test do
    system "#{bin}/activemq", "browse", "-h"
  end
end
