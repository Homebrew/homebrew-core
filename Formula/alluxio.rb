class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.9.2/alluxio-2.9.2-bin.tar.gz"
  sha256 "d511cc8ad3f5249f9f471e0fa5193945f13390ade4cedddec5cb29d3989cf1d0"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8e749ffce5b7ec29fc80b9cc955600b095959e748395bc306e316acd1af849f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e749ffce5b7ec29fc80b9cc955600b095959e748395bc306e316acd1af849f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8e749ffce5b7ec29fc80b9cc955600b095959e748395bc306e316acd1af849f"
    sha256 cellar: :any_skip_relocation, ventura:        "3019c4436d34bdfa4cf6d3797ad92619ca5c2c68c3b093074d4c195773ae94d1"
    sha256 cellar: :any_skip_relocation, monterey:       "3019c4436d34bdfa4cf6d3797ad92619ca5c2c68c3b093074d4c195773ae94d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3019c4436d34bdfa4cf6d3797ad92619ca5c2c68c3b093074d4c195773ae94d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e749ffce5b7ec29fc80b9cc955600b095959e748395bc306e316acd1af849f"
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
