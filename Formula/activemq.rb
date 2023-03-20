class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.17.4/apache-activemq-5.17.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.17.4/apache-activemq-5.17.4-bin.tar.gz"
  sha256 "ca485db5d8e78e8dd485a84413ed82f55e4a7021b8d332428def2a20f2e5c7c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1e9df917ddbf6febc6f49cd88fb6eba3301557c4544552e3989d2a72bdae1dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04aa0a30ff07854590cab2bffd16b5cf3c12f6c6b10591c08775ae82acd31129"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef38869ce29be2b6029ad36a41abde6cb4e642facdd1fe41370a7d1d5871b3a9"
    sha256 cellar: :any_skip_relocation, ventura:        "3813959d7d5c24899b32c8639d60c9c8807920f959c844f5bc8a4bf2819dbdf9"
    sha256 cellar: :any_skip_relocation, monterey:       "b03e966e0939bdeeeda40540057a07738a018c29bce72f663644c6cf9a6e0ba5"
    sha256 cellar: :any_skip_relocation, big_sur:        "62f15a4cabccce576aa523f6a2ec6710d5ea5d6c35d2d00937c3fbabee35af23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c05b2aa51a40b0249a8adcb8071ee46af7830e4d5ccb6764921cdffe80d3da"
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
