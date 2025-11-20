class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.1.0/fabric-installer-1.1.0.jar"
  sha256 "c20c407d5ca4b119aae97847eb2fbb1d34c92969b647fbbb1de2fd36ca00738e"
  license "Apache-2.0"

  # The first-party download page (https://fabricmc.net/use/) uses JavaScript
  # to create download links, so we check the related JSON data for versions.
  livecheck do
    url "https://meta.fabricmc.net/v2/versions/installer"
    strategy :json do |json|
      json.map do |release|
        next if release["stable"] != true

        release["version"]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ee052ef1cb22a4a7527380d7f41802ca098fcd3fbbf9d3289bc3470d0df5e13"
  end

  depends_on "openjdk"

  def install
    libexec.install "fabric-installer-#{version}.jar"
    bin.write_jar_script libexec/"fabric-installer-#{version}.jar", "fabric-installer"
  end

  test do
    system bin/"fabric-installer", "server"
    assert_path_exists testpath/"fabric-server-launch.jar"
  end
end
