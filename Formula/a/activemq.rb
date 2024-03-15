class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/6.1.0/apache-activemq-6.1.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/6.1.0/apache-activemq-6.1.0-bin.tar.gz"
  sha256 "4c82f5806d76f4ab25cdde14164c14af9e3dd84f1278741b610a82db2d7fe3e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3edd1eac3a62a8a6899b7617a7aa5b045125b731de31fe7ec45ebb5f59a0aeb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8dccbe3d26b41710e2f008bf0d272887d67d08fee9931e8d73bbab14170156c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c21b3d9ef504117cc74de5731c582570db549ddf5124117530d49bbdf82f5b67"
    sha256 cellar: :any_skip_relocation, sonoma:         "72c0b9a37c5e9be4495394776012248ba0b4c00fcccdab68d9835fc4f43fe0df"
    sha256 cellar: :any_skip_relocation, ventura:        "a3c6030f695ec2e8e57433394cdec1121771287158757697b84d9edadbdf17d9"
    sha256 cellar: :any_skip_relocation, monterey:       "659570f65231a3a3a7e7f60bff2dc3f5e88d42bba15f0727f87947422da2ea9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e877550d49233a2d348293f5cb67b8910dfed574a54d6db40fc9ac067dfbdfc8"
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
