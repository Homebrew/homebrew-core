class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  # https://www.embulk.org/articles/2020/03/13/embulk-v0.10.html
  # v0.10.* is a "development" series, not for your production use.
  # In your production, keep using v0.9.* stable series.
  url "https://github.com/embulk/embulk/releases/download/v0.9.24/embulk-0.9.24.jar"
  sha256 "acf204ffa0112ae4fd6757b4557fef6f72e2d5dd163af439f8b13ae98fb9dafd"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{(?<!un)Stable.+?href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf6500c8b780a8b842484e34d7d451e433b9c1ebbcb39c60531423649d01bb4f"
  end

  depends_on "openjdk@8"

  def install
    libexec.install "embulk-#{version}.jar"
    bin.write_jar_script libexec/"embulk-#{version}.jar", "embulk", java_version: "1.8"
  end

  test do
    system bin/"embulk", "example", "./try1"
    system bin/"embulk", "guess", "./try1/seed.yml", "-o", "config.yml"
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
