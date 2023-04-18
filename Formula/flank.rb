class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.03.2/flank.jar"
  sha256 "e95d92a3f8044fb990308b50d9613ccde43376af3e745417e6e7c63b11d5968f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c865b27467c18d0fb7e55291bd38ada7154c8e6a6632377018763649c1334bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c865b27467c18d0fb7e55291bd38ada7154c8e6a6632377018763649c1334bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c865b27467c18d0fb7e55291bd38ada7154c8e6a6632377018763649c1334bf"
    sha256 cellar: :any_skip_relocation, ventura:        "5c865b27467c18d0fb7e55291bd38ada7154c8e6a6632377018763649c1334bf"
    sha256 cellar: :any_skip_relocation, monterey:       "5c865b27467c18d0fb7e55291bd38ada7154c8e6a6632377018763649c1334bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c865b27467c18d0fb7e55291bd38ada7154c8e6a6632377018763649c1334bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cd34cf514a5610bb4c159e568815bf2ffafd07aa98d5ece1ae988eef9c3b23b"
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
