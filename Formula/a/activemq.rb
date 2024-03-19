class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.0/apache-activemq-6.1.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.0/apache-activemq-6.1.0-bin.tar.gz"
  sha256 "4c82f5806d76f4ab25cdde14164c14af9e3dd84f1278741b610a82db2d7fe3e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fb31be689ced27442973d8828d547242d92e07a069334e1635f8798cbc86794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd1eaaad89d2dc6468b3f0b5e7bc586f45a01dbc116f1aaf3348402019c7aa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f756f1662504242c55b7ff1e91fec97dc47f1b150b91a1456c3cca47aa08ae0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6119542fc7b6350edd6b96a0650199868a9ccfa304fff4e755d76882f31b42e0"
    sha256 cellar: :any_skip_relocation, ventura:        "e0c23602211e7993524bca8e7572c175b1e45182d5bc763e73c3e56f52fbc231"
    sha256 cellar: :any_skip_relocation, monterey:       "3ab86369b31600c2059d48f6f229e01ff372e815846710b0b13c842cf69823c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2534517c88a8916eae8b0dac5f8956378ba00ded2499d3a1e26fed50d3cb47"
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
