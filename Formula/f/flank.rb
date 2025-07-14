class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.10.1/flank.jar"
  sha256 "719ba0ca5744f571aad01fc61392b18990833ee9dd36e6b600ccdff614350d58"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f6c1c7a433156099db3565266cc19220b34233bd230df04b5845c952c8462100"
  end

  depends_on "openjdk"

  def install
    libexec.install "flank.jar"
    bin.write_jar_script libexec/"flank.jar", "flank"
  end

  test do
    (testpath/"flank.yml").write <<~YAML
      gcloud:
        device:
        - model: Pixel2
          version: "29"
          locale: en
          orientation: portrait
    YAML

    output = shell_output("#{bin}/flank android doctor")
    assert_match "Valid yml file", output
  end
end
