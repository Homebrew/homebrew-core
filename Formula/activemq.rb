class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.17.0/apache-activemq-5.17.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.17.0/apache-activemq-5.17.0-bin.tar.gz"
  sha256 "eb06abd7f45efad42f4f56b671fee7dff4ccac387e0765b1d256e19bea66f897"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e44d8c98bb98950feba410e9f99f43c9423057fbf2762c69ff3b9f1935db69c"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e729e282ec91d20565892e5af21e41901df77717bc4c38e4a0a9277e6443eeb"
    sha256 cellar: :any_skip_relocation, catalina:      "fc7ec05532568cb610c161ba2c7050941ee3c9ec6bd0e23e544e2cdb62b425d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c77a23d5a9d62036cd3617525cf875c01f50343c7ab903f521e93809194b5233"
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
