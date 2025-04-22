class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.3/fabric-installer-1.0.3.jar"
  sha256 "38aa82ab1ef829b7aa3f2143fcc93bba706a8e18835be731d0fdf231d274b07f"
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
    sha256 cellar: :any_skip_relocation, all: "d11dda83fc820062d1bf50f4c2df042c2aa5dfbe8092735b24733010e7a140c4"
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
