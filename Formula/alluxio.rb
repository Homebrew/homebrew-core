class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.9.3/alluxio-2.9.3-bin.tar.gz"
  sha256 "c71abc5e852d37cfd6b1dea076f056c6997e3f60fbb940bf005acb3a6354a369"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c38d5e85079041c189c0fe008618802ee1a87f2efb94f1b3d0be35c23e27ec01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c38d5e85079041c189c0fe008618802ee1a87f2efb94f1b3d0be35c23e27ec01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c38d5e85079041c189c0fe008618802ee1a87f2efb94f1b3d0be35c23e27ec01"
    sha256 cellar: :any_skip_relocation, ventura:        "f32a22feeccef5d59267a8936b1bc400996e96bd0a8f935eccf30fa8afb74722"
    sha256 cellar: :any_skip_relocation, monterey:       "f32a22feeccef5d59267a8936b1bc400996e96bd0a8f935eccf30fa8afb74722"
    sha256 cellar: :any_skip_relocation, big_sur:        "f32a22feeccef5d59267a8936b1bc400996e96bd0a8f935eccf30fa8afb74722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c38d5e85079041c189c0fe008618802ee1a87f2efb94f1b3d0be35c23e27ec01"
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
    assert_match "Validating configuration.", output

    output = shell_output("#{bin}/alluxio clearCache 2>&1", 1)
    expected_output = OS.mac? ? "drop_caches: No such file or directory" : "drop_caches: Read-only file system"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/alluxio version")
  end
end
