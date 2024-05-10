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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0abb98eb09b14724c649c732d9fb0940a7778f5d0901feae8c2227dda0afa39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0abb98eb09b14724c649c732d9fb0940a7778f5d0901feae8c2227dda0afa39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0abb98eb09b14724c649c732d9fb0940a7778f5d0901feae8c2227dda0afa39"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0abb98eb09b14724c649c732d9fb0940a7778f5d0901feae8c2227dda0afa39"
    sha256 cellar: :any_skip_relocation, ventura:        "a0abb98eb09b14724c649c732d9fb0940a7778f5d0901feae8c2227dda0afa39"
    sha256 cellar: :any_skip_relocation, monterey:       "a0abb98eb09b14724c649c732d9fb0940a7778f5d0901feae8c2227dda0afa39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e5506a59b1f5688bb0688dccb223160c11bf3463b5588768a91d653abe4606"
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
