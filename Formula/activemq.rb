class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.17.2/apache-activemq-5.17.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.17.2/apache-activemq-5.17.2-bin.tar.gz"
  sha256 "4216387240ef38e912f88162c52e26128f0f72d15910852d12eb0a7845819195"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52e1a4a76f44e1644213fa3e6637b129f075648f702f4415e162f5288c6743d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b210c29c07a8ed7a0d4c1767f3db980d0889e37745b4965c66bfcc7180cfa4c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73b3b53c4db3ef9abc61beae4c3cf790b3cabd8c3f90589312376fb5e9803c50"
    sha256 cellar: :any_skip_relocation, ventura:        "d8c2d4edd024334a4990d452281a43132e26a545e8472b95e4d5e872ad434db8"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c58cef63893bcc281d051e11f730465bfc57f6c8e3d0040456ff4a04cb9ed0"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfb6c7c27e9eb6bc1e1f116ac96fcde265f457e1bc24c60ce09872276e3c7050"
    sha256 cellar: :any_skip_relocation, catalina:       "65abfc596db7301ead3df54156330bc73e55253c50d14c27282de54b94695238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b75728c3d19fa4f31f8b3f5e634285d69788c6be4bc84e3159e18735ae63ab"
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
