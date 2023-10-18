class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.10.0/flank.jar"
  sha256 "8b22a99abb6d14c3e7a908f2ce89fa4aeb6b6776890ef916fa8d2c40774aa6c6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b52967a2abf16b58cd6922ad76f93daf6d7820d3696d8393fdbfad69dfac695c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b52967a2abf16b58cd6922ad76f93daf6d7820d3696d8393fdbfad69dfac695c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b52967a2abf16b58cd6922ad76f93daf6d7820d3696d8393fdbfad69dfac695c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b52967a2abf16b58cd6922ad76f93daf6d7820d3696d8393fdbfad69dfac695c"
    sha256 cellar: :any_skip_relocation, ventura:        "b52967a2abf16b58cd6922ad76f93daf6d7820d3696d8393fdbfad69dfac695c"
    sha256 cellar: :any_skip_relocation, monterey:       "b52967a2abf16b58cd6922ad76f93daf6d7820d3696d8393fdbfad69dfac695c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be0d5140adbe81d23d2d198d6b9083bc6e57afa5929c110eaa320538c321383f"
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
