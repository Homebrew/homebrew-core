class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v22.03.0/flank.jar"
  sha256 "dcd93557ac657d45e16dd13d05e9ccf557ba557e6087fe6ad2dfdd0f5a7fcb06"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3999a3762e57955b71194e1cd2bcd07a89ed27e9e520591f1b567d2d6619200e"
  end

  depends_on "openjdk"

  def install
    libexec.install "flank.jar"
    bin.write_jar_script libexec/"flank.jar", "flank"
  end

  test do
    (testpath/"flank.yml").write <<~EOS
      gcloud:
        device:
        - model: Pixel2
          version: "29"
          locale: en
          orientation: portrait
    EOS

    output = shell_output("#{bin}/flank android doctor")
    assert_match "Valid yml file", output
  end
end
