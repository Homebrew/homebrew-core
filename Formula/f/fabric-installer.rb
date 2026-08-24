class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.1.2/fabric-installer-1.1.2.jar"
  sha256 "61e035bf7bf70153e127440ce34de47c9036f0a2d0c65d1529454bd35ceefe4f"
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
    sha256 cellar: :any_skip_relocation, all: "f39d9f4cb764e71d737597f83db459697a047a2453fb4206a7d88e48520f1ae4"
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
