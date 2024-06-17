class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.2/apache-activemq-6.1.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.2/apache-activemq-6.1.2-bin.tar.gz"
  sha256 "109656ac6bd7202c69f9e0f3ad7e413e797f66e50c3bbbad2a0692d9ce08050d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28f1a92bea97f49b83be34a9664988c912a9b69f076e11a3095c3d3c366957fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "432c917acef639308a14ee75c386ca976a9b4fb6a946299c095acec11f15f49c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfcbaa903cdefb3a880e9f02744edb393858b461aaaf4bbc746c9482776636aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "362a97233c4b88093453c45d5d4ef94a3c3aafb9ad78e6b9f54a204e7f846203"
    sha256 cellar: :any_skip_relocation, ventura:        "35b6e3057c2024af6d07d3a5516647c0e165e98ab776fe67c7363568f0fe68db"
    sha256 cellar: :any_skip_relocation, monterey:       "e8ed1c54ad89cd3ff9b4c0ca7aeda1ec64760acf7689b1d81a904c5f38fb26db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eab33df70e641f05430120ad1b1e767c019006530f383f11bffff7bb8fa1e285"
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
