class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.17.4/apache-activemq-5.17.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.17.4/apache-activemq-5.17.4-bin.tar.gz"
  sha256 "ca485db5d8e78e8dd485a84413ed82f55e4a7021b8d332428def2a20f2e5c7c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c55bea01c00d9296476958c2ba76ba70e7c8faff1a07d0ee780321e1bb3d987"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f19e6b4f5f27f29f0c96ed3a907d9723d19abe4183207bfe4c9c64ffdcfdf5cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f1eb1be2a00a89006e6ef6c7758906623cbed733a50a799a6578296b276fc63"
    sha256 cellar: :any_skip_relocation, ventura:        "0e06241f9a21802366786397ab543ce18b5bfeeb09caeeaeef5b81b2e123dbce"
    sha256 cellar: :any_skip_relocation, monterey:       "6b1703e5ba80d3f59407f63277b5a66f3c819885f8783806816a4f37643f5fb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c52e7df7035b2e7aef646371b5e48c5ac3e522f18e12d5411d28d3b9699b8a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "134ed8c69b96290bc83505e5e24f001d6e005a641a69990a99a8e2eb59169abf"
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
