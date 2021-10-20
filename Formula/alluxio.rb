class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.6.2/alluxio-2.6.2-bin.tar.gz"
  sha256 "f41ab75bb6105eca6c34b58bc1d60f4857816dd3cae8a21d599237568656dc2e"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9216fc23f390a794e4b0d6b54ff6ffb11fb0b1a15534d54de64af31a2d270078"
    sha256 cellar: :any_skip_relocation, big_sur:       "616c3f9b7fde2974253baa71cd0289758d55e0fc8ecb0b591b7343932ad5fccd"
    sha256 cellar: :any_skip_relocation, catalina:      "616c3f9b7fde2974253baa71cd0289758d55e0fc8ecb0b591b7343932ad5fccd"
    sha256 cellar: :any_skip_relocation, mojave:        "616c3f9b7fde2974253baa71cd0289758d55e0fc8ecb0b591b7343932ad5fccd"
  end

  # Alluxio requires Java 8 or Java 11
  depends_on "openjdk@11"

  def default_alluxio_conf
    <<~EOS
      alluxio.master.hostname=localhost
    EOS
  end

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")
    chmod "+x", Dir["#{libexec}/bin/*"]

    rm_rf Dir["#{etc}/alluxio/*"]

    (etc/"alluxio").install libexec/"conf/alluxio-env.sh.template" => "alluxio-env.sh"
    ln_sf "#{etc}/alluxio/alluxio-env.sh", "#{libexec}/conf/alluxio-env.sh"

    defaults = etc/"alluxio/alluxio-site.properties"
    defaults.write(default_alluxio_conf) unless defaults.exist?
    ln_sf "#{etc}/alluxio/alluxio-site.properties", "#{libexec}/conf/alluxio-site.properties"
  end

  def caveats
    <<~EOS
      To configure alluxio, edit
        #{etc}/alluxio/alluxio-env.sh
        #{etc}/alluxio/alluxio-site.properties

      To use `alluxio-fuse` on macOS:
        brew install --cask macfuse
    EOS
  end

  test do
    output = shell_output("#{bin}/alluxio validateConf")
    assert_match "ValidateConf - Validating configuration.", output

    output = shell_output("#{bin}/alluxio clearCache 2>&1", 1)
    assert_match "drop_caches: No such file or directory", output

    assert_match version.to_s, shell_output("#{bin}/alluxio version")
  end
end
