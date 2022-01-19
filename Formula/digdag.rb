class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.10.4.jar"
  sha256 "2020fa9395e74e14fdf4ada93bff0684dcea64f564788afd6a3ecc54e3bbd4bf"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/treasure-data/digdag.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ca2ef842dc4f5b70a20896b7ba3fbeb34d14537b5dfc081ebe3e4c7150c04e8f"
  end

  depends_on "openjdk@8"

  def install
    libexec.install "digdag-#{version}.jar"
    bin.write_jar_script libexec/"digdag-#{version}.jar", "digdag", java_version: "1.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/digdag --version")
  end
end
