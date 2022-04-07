class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.7.4/alluxio-2.7.4-bin.tar.gz"
  sha256 "d4e624c78a2c8288d578776061c6732f6287f980feb9d160fb0e403456f65a2d"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e4f7fdc6e3a0bea6219e5dede281af211b2bf4009b84d182f3e86bd899d90e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91e4f7fdc6e3a0bea6219e5dede281af211b2bf4009b84d182f3e86bd899d90e"
    sha256 cellar: :any_skip_relocation, monterey:       "3d13c3e73706ea08eb03d47b7fe9f4102c30a5bb9333e075936e541ab25184ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d13c3e73706ea08eb03d47b7fe9f4102c30a5bb9333e075936e541ab25184ca"
    sha256 cellar: :any_skip_relocation, catalina:       "3d13c3e73706ea08eb03d47b7fe9f4102c30a5bb9333e075936e541ab25184ca"
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
