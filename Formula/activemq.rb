class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.18.1/apache-activemq-5.18.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.18.1/apache-activemq-5.18.1-bin.tar.gz"
  sha256 "fedd7bde9af5babaeb072bf7aeb2065d9021c26163ded639c87a32d673795472"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf2326f7e23dca46fdb5da8a5a1c789a7cea15b84ad2cbcbe535919a073cab3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61a77030abd2bb0f0751fe33a4ab632c3c37183493e2f096f7f3105131c01693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8d7c2356da1ee8c221536415d37bc5c1bcd7f5cea819457ad043eb6af0c16e3"
    sha256 cellar: :any_skip_relocation, ventura:        "87bd1bd6908b6fddd7bb954a5d053c4e245d80c91e5902f64dbcd32d1d89acf4"
    sha256 cellar: :any_skip_relocation, monterey:       "2de2eede2a3749d776a23874dfaadc36d65b35fd5099edf5cd25e1ce6de744b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d0b9287680c33f0adba3a61ae98fcd4e5d1a94eb3e2456a7436492830b9a08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3381650364347a04582b17f03b6b257df85d9fb53b402486982fdf6c42fd177"
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
