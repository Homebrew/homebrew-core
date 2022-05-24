class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.8.0/alluxio-2.8.0-bin.tar.gz"
  sha256 "d2819ea49a14182b1406ed61796026605510abca8f53adeda1ae05305057d1ef"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d845e46e556e33ec02e69b51cad893eb6296fe49d5f699aefe346b161fdbfabe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d845e46e556e33ec02e69b51cad893eb6296fe49d5f699aefe346b161fdbfabe"
    sha256 cellar: :any_skip_relocation, monterey:       "8f28c665a49d478eaab64e044bc9a6773cd0f66548277434b53a00b29ac6dec9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f28c665a49d478eaab64e044bc9a6773cd0f66548277434b53a00b29ac6dec9"
    sha256 cellar: :any_skip_relocation, catalina:       "8f28c665a49d478eaab64e044bc9a6773cd0f66548277434b53a00b29ac6dec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10e26cdd6744eb4db06575f50f636aa0b16db47ca284a25e3bb827352c27b0e4"
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
    expected_output = OS.mac? ? "drop_caches: No such file or directory" : "drop_caches: Read-only file system"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/alluxio version")
  end
end
