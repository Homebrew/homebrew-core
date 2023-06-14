class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.06.1/flank.jar"
  sha256 "c376ba3ddca7ad1f89b81aad1d03e065034ebde8dd03c8c37fee1c3dd8553f14"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af49bfd7c9cd0bc91cec9fe8194f3e4a5fb63deecf2e9553805850c10eae7aa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af49bfd7c9cd0bc91cec9fe8194f3e4a5fb63deecf2e9553805850c10eae7aa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af49bfd7c9cd0bc91cec9fe8194f3e4a5fb63deecf2e9553805850c10eae7aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "af49bfd7c9cd0bc91cec9fe8194f3e4a5fb63deecf2e9553805850c10eae7aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "af49bfd7c9cd0bc91cec9fe8194f3e4a5fb63deecf2e9553805850c10eae7aa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "af49bfd7c9cd0bc91cec9fe8194f3e4a5fb63deecf2e9553805850c10eae7aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be18a796b3cccf87f2046e008ad4d5f8989ed5b02bc27dabca0c3dc0f3694c2"
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
