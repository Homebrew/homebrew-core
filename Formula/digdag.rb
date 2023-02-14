class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.10.5.jar"
  sha256 "97b50ae37dd5f96e44e9557846ba7b5cddfea0b1b927d7597886dc604f9387b6"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/treasure-data/digdag.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e8af040e14f05c1f648ef90f3e0e7da9037d7e813cfb1fc7c644d174244d0cf"
  end

  depends_on "openjdk@11"

  def install
    libexec.install "digdag-#{version}.jar"
    bin.write_jar_script libexec/"digdag-#{version}.jar", "digdag", java_version: "11"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/digdag --version")
  end
end
