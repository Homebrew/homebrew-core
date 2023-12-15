class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  # https://www.embulk.org/articles/2020/03/13/embulk-v0.10.html
  # v0.10.* is a "development" series, not for your production use.
  # In your production, keep using v0.9.* stable series.
  url "https://github.com/embulk/embulk/releases/download/v0.11.0/embulk-0.11.0.jar"
  sha256 "16664089e2676d5f7fe71c1ccf48b2a24f982b89e4f483e650a15f52a72309c1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{(?<!un)Stable.+?href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "25352302442b5fa9c22bc2bb9ff04cadc69527ee42d9974a717b6bc46df0b58f"
    sha256 cellar: :any_skip_relocation, monterey:     "25352302442b5fa9c22bc2bb9ff04cadc69527ee42d9974a717b6bc46df0b58f"
    sha256 cellar: :any_skip_relocation, big_sur:      "25352302442b5fa9c22bc2bb9ff04cadc69527ee42d9974a717b6bc46df0b58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f18e539ca70420cd3cc6fb7f7b24cc1d761ecb9cf7af7121d576a0727a17586f"
  end

  # Only Java 8 is officially supported and guaranteed to be compatible with
  # plugins. However `openjdk@8` does not support Apple Silicon so we use one
  # of the latest of Java versions (11 or 17) upstream plans to test.
  #
  # Ref: https://www.embulk.org/#quick-start
  # Ref: https://github.com/embulk/embulk/issues/1595
  on_arm do
    depends_on "openjdk@17"
  end
  on_intel do
    depends_on "openjdk@8"
  end

  def install
    libexec.install "embulk-#{version}.jar"
    java_version = Hardware::CPU.arm? ? "17" : "1.8"
    bin.write_jar_script libexec/"embulk-#{version}.jar", "embulk", java_version: java_version
  end

  test do
    system bin/"embulk", "example", "./try1"
    system bin/"embulk", "guess", "./try1/seed.yml", "-o", "config.yml"
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
