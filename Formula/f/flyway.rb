class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/9.21.1/flyway-commandline-9.21.1.tar.gz"
  sha256 "a5b64daa57b81312c6a08089ba627de0f6272f6d9bc597c774ccd66e8dcfe0d5"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4489b415bfe86f09c5a7a91a3fa025b872bc660f8394005aa00dec6da8702a85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4489b415bfe86f09c5a7a91a3fa025b872bc660f8394005aa00dec6da8702a85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4489b415bfe86f09c5a7a91a3fa025b872bc660f8394005aa00dec6da8702a85"
    sha256 cellar: :any_skip_relocation, ventura:        "4489b415bfe86f09c5a7a91a3fa025b872bc660f8394005aa00dec6da8702a85"
    sha256 cellar: :any_skip_relocation, monterey:       "4489b415bfe86f09c5a7a91a3fa025b872bc660f8394005aa00dec6da8702a85"
    sha256 cellar: :any_skip_relocation, big_sur:        "4489b415bfe86f09c5a7a91a3fa025b872bc660f8394005aa00dec6da8702a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b974493ea4fc5f03eec222b2c7cc62a8072d8422c60afd606588ebb296c9ce86"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
