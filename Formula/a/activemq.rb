class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.5/apache-activemq-6.1.5-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.5/apache-activemq-6.1.5-bin.tar.gz"
  sha256 "26b2cb4a6ebe05ed6f4814d3af245c65f6e218ad0fae627fa4cdae6271ae37d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c5cd8b835047b64259e6bd77e1df13139d308f08fd748b97d65a7f1b2242539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e26bcb9d03f23de02eb4d2300e1ae9e4b5b28e477501cf06040a78534ae452"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15ac958b2899e8ee057453a075805c317ea759790d358ba68e581a94fc8cad43"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae1e0ea2314464078e41b3d7eae5c1aff2e30b294b263570b0c482fc0018f26a"
    sha256 cellar: :any_skip_relocation, ventura:       "ae661e1e17aa40ffe5fcc72d9002e0c3ce5385371fb75dea7946603b52ab67e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a009106acf3da8f0b59d6410818af5d6d7352be6898efa2af959ac2a60bb5e29"
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
    system bin/"activemq", "browse", "-h"
  end
end
