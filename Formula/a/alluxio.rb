class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.9.4/alluxio-2.9.4-bin.tar.gz"
  sha256 "21ec1fbe838a998d3bfd1072b07fbcac0919052c810df49d006f89b52d471b4b"
  license "Apache-2.0"

  livecheck do
    url "https://downloads.alluxio.io/downloads/files/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee2165942c8045736442df9c8ed037f87f8fd50b7084f523843a6283e72fcf7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4619c00c44fddb043e4729b1251f285f303e462840051444ff8c4b6d3c9245b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e3e943800cb2350e0e82a468a42d0066532186b47a1f9414b9acce1d787353c"
    sha256 cellar: :any_skip_relocation, sonoma:         "127180143bd1a2d51c5826a6469f6f329c7b5b7d74dedb77830318e15e2d48f6"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb5f9f98a26b7636b6be4e6398fe3ef7d36deaeba975685991d54c8597cd380"
    sha256 cellar: :any_skip_relocation, monterey:       "0193caf06e8487dadb265ac8243fc2c630bc5b9b338adaae280233d2374aac3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36effc790aeb3ad08f51f91adbaafd0c5e5e45f746e51c602f2f33c61162def"
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
