class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.7.3/alluxio-2.7.3-bin.tar.gz"
  sha256 "33838d275f1acc8ec382e82535ce8363b52384ef443409dc53ae9c6299ccd1b0"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d457646f79f9430802f90afdbe45073353712f7cf480e1e7907ce218974d890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d457646f79f9430802f90afdbe45073353712f7cf480e1e7907ce218974d890"
    sha256 cellar: :any_skip_relocation, monterey:       "5afaefa0a74af1e2bb8d19212a77d4627289fe317ac36efa3ca3a6b0ddfb84be"
    sha256 cellar: :any_skip_relocation, big_sur:        "5afaefa0a74af1e2bb8d19212a77d4627289fe317ac36efa3ca3a6b0ddfb84be"
    sha256 cellar: :any_skip_relocation, catalina:       "5afaefa0a74af1e2bb8d19212a77d4627289fe317ac36efa3ca3a6b0ddfb84be"
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
