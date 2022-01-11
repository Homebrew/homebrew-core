class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.7.2/alluxio-2.7.2-bin.tar.gz"
  sha256 "e428acfe0704cc68801ae2aa7b7ba920a0e35af9dded66b280649fc1d280a3d4"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a50ee2f9a8b7a486fddf67f61b03f19783855ab13eb193b972f7f9c5b4f72d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2c73e41d28cbd794ea51c286987641e796eac18de2124745eeb25ca3862f244"
    sha256 cellar: :any_skip_relocation, catalina:      "d2c73e41d28cbd794ea51c286987641e796eac18de2124745eeb25ca3862f244"
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
