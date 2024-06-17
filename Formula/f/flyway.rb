class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.15.0/flyway-commandline-10.15.0.tar.gz"
  sha256 "c3a5c9e8ac362347708d795259375c68b56683d5bbef49956801460cf6cfe6b7"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2df0ecbf23e8076d4be14da739e1793cb01014353cdaf1f7196adda4f47599a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2df0ecbf23e8076d4be14da739e1793cb01014353cdaf1f7196adda4f47599a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2df0ecbf23e8076d4be14da739e1793cb01014353cdaf1f7196adda4f47599a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2df0ecbf23e8076d4be14da739e1793cb01014353cdaf1f7196adda4f47599a7"
    sha256 cellar: :any_skip_relocation, ventura:        "2df0ecbf23e8076d4be14da739e1793cb01014353cdaf1f7196adda4f47599a7"
    sha256 cellar: :any_skip_relocation, monterey:       "2df0ecbf23e8076d4be14da739e1793cb01014353cdaf1f7196adda4f47599a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e42cdeffbb270a8b6c90841463977e0102dc7f2c941b98432ba4e7080997d3"
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
