class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.16.4/apache-activemq-5.16.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.16.4/apache-activemq-5.16.4-bin.tar.gz"
  sha256 "f8e04d8a810141b386a5c9c3960b5f01e8fe73461f4c99b191e115d493840701"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b21f6a33e97037eb0f2610588e1be30d59c45dfdea65f5633eb15463f1bed5ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96fea1abd0d9c574c1180eef96b627d25557d76421cbf69d0be648ae5a448eb9"
    sha256 cellar: :any_skip_relocation, monterey:       "555c0807f5ed9ba4381c908581851eb00ef9bc02536e5c96780648894d862393"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0feb1f5e6b47220ddfff5bcb293da5d44d096294c773b3a94cf89fcd9cecab6"
    sha256 cellar: :any_skip_relocation, catalina:       "e0feb1f5e6b47220ddfff5bcb293da5d44d096294c773b3a94cf89fcd9cecab6"
    sha256 cellar: :any_skip_relocation, mojave:         "e0feb1f5e6b47220ddfff5bcb293da5d44d096294c773b3a94cf89fcd9cecab6"
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
