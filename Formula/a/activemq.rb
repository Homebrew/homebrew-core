class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.3/apache-activemq-6.1.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.3/apache-activemq-6.1.3-bin.tar.gz"
  sha256 "cad14e816e990f1312709ebfc228f42895d8c54c652d3cd56f0b5145635dc794"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd0dfc580d6eb5d4ce59737872fa38e3f5249308364104cf26c5eff8e65a80f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a29869c57b4bd7467181a1e1ad99e8a2716fa3e523f66dfb6ca1bf21afbc47be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "583263dcbe34a451a96b1d0f4d049ea0a92e5b6b02227663f7a147e71f6ec3fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecfd2e949264406479e5002d43715258316155ee59d63cb05bf71f3f7de498bc"
    sha256 cellar: :any_skip_relocation, ventura:        "ddf65ea177a13d2b13d043a9e21bba44cb8a03d8cb3d58c340f6209ffc25a523"
    sha256 cellar: :any_skip_relocation, monterey:       "ed437a8fb40d66072e52dc1965e44907324a20265ce3843efd0819a7f4ac3a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1bcab1a02b097d92e4a35aad0f2a7426193db590e473d1405254690eb3d071"
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
