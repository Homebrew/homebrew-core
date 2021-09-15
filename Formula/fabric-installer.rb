class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.7.4/fabric-installer-0.7.4.jar"
  sha256 "192d60fb544a45edca589a4f73d9d3df93a7f7b68a407c0403e9e1802faf7668"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c309d182810665ba504617c038a5af04bc3c6aba5b04034753227bda46ff78b"
  end

  depends_on "openjdk"

  def install
    libexec.install "fabric-installer-#{version}.jar"
    bin.write_jar_script libexec/"fabric-installer-#{version}.jar", "fabric-installer"
  end

  test do
    system "#{bin}/fabric-installer", "server"
    assert_predicate testpath/"fabric-server-launch.jar", :exist?
  end
end
