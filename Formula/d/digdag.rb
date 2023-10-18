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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "787d866fdde49da3b57825b62fdb89e860b388e56879ae978a4fc455e7d5f3b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e37d28f1924c0650e7cdb521183d22ac6121ed56369108ed95ad3fe59a29646e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e37d28f1924c0650e7cdb521183d22ac6121ed56369108ed95ad3fe59a29646e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e37d28f1924c0650e7cdb521183d22ac6121ed56369108ed95ad3fe59a29646e"
    sha256 cellar: :any_skip_relocation, sonoma:         "787d866fdde49da3b57825b62fdb89e860b388e56879ae978a4fc455e7d5f3b3"
    sha256 cellar: :any_skip_relocation, ventura:        "e37d28f1924c0650e7cdb521183d22ac6121ed56369108ed95ad3fe59a29646e"
    sha256 cellar: :any_skip_relocation, monterey:       "e37d28f1924c0650e7cdb521183d22ac6121ed56369108ed95ad3fe59a29646e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e37d28f1924c0650e7cdb521183d22ac6121ed56369108ed95ad3fe59a29646e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90e288ab66481212d6aa5e095300b1b769eee3b5e8ef20a1b334977bed073e5"
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
