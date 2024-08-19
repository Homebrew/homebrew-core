class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.9.5/alluxio-2.9.5-bin.tar.gz"
  sha256 "a85fb49654599f813661f9b8fc68d507774746258c607af33b9b2b12f16feaba"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d18718fb624fd2db394d87aaca2d4a35b81530e6c78f85970a08fc8c8cb9f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d18718fb624fd2db394d87aaca2d4a35b81530e6c78f85970a08fc8c8cb9f74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d18718fb624fd2db394d87aaca2d4a35b81530e6c78f85970a08fc8c8cb9f74"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a6e404c0c07fc013a139a7ac6e4020b82b15ed3a0d162e3ad2ebddbd3810979"
    sha256 cellar: :any_skip_relocation, ventura:        "3a6e404c0c07fc013a139a7ac6e4020b82b15ed3a0d162e3ad2ebddbd3810979"
    sha256 cellar: :any_skip_relocation, monterey:       "3a6e404c0c07fc013a139a7ac6e4020b82b15ed3a0d162e3ad2ebddbd3810979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13898f6e04b21f80fe62ce9bdeff3b46b13e855324870471b1810255ec37b520"
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

    rm_r(Dir["#{etc}/alluxio/*"])

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
    assert_match "Validating configuration.", output

    output = shell_output("#{bin}/alluxio clearCache 2>&1", 1)
    expected_output = OS.mac? ? "drop_caches: No such file or directory" : "drop_caches: Read-only file system"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/alluxio version")
  end
end
