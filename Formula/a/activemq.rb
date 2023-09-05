class Activemq < Formula
  desc "Apache ActiveMQ: powerful open source messaging server"
  homepage "https://activemq.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/5.18.2/apache-activemq-5.18.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/activemq/5.18.2/apache-activemq-5.18.2-bin.tar.gz"
  sha256 "cd3df3ec2f791d47f4351bc0e5d5f9880c220a451a31820edbf839962ec8430a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b0c952a8e56a52f8f1fdf3a82ad5ae901fd028d1c1f4e04d3cee66e05ccec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95bececfb3d00a1b12b6ba5f1278e6f0c0bd75e133814b8c4519713909fad723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "306b098ca800f9e54c4cebc20a2fce8ba711cf42601ebcae89fda974e96310ab"
    sha256 cellar: :any_skip_relocation, ventura:        "ad2bb9bbf173ae56a246550eca6f7439780c26f87e10ad94db74725046c896b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f2dacfab2df8a1430c05142ddbddce2f21b375a45179c3f65b608b4bd09d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "017f8b8312ea6f01d69d1e7e9c42f34e85dc81199366f425c033503bcfd215c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8900b73fccb19c748158b980c96984f1b977eec36ac2cadac31dcc2be536ca51"
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
