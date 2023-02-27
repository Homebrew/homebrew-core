class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.11.2.tar.gz"
  sha256 "0e078b37fe1ba1a9ca7191e706818e3b423588cac55484dda82dbbd1cdfe0b24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b108fdcbbbaa38298f3a7301e05c8ffcef457526d8852ae8a4d263a0deb6ac39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06426726661799e46b4c8929ec508d9208b01203f9e22307a6824a3ace5271cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d284f171bc0059cbed05743d3e3d66bbb20102a0ba10c0a328fae523866ad5a9"
    sha256 cellar: :any_skip_relocation, ventura:        "2c7bf01481c17630137f8f9be1cd8f6e2413634c0e13060d56ff593541ff622b"
    sha256 cellar: :any_skip_relocation, monterey:       "c618b02253d978153c2beb9be03db15b37d23939efdbb9452af3a8d3fa63a454"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7fe60cb94a979432b20323000bfa21c0d6f90101f53e98c45f0201a1ea3ccf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48300591ae3b0f38ca254b2c95261d002464fddcdbcbb5fddd9a1b0e615839eb"
  end

  depends_on "openjdk@11"

  def install
    ENV["CIRCLE_TAG"] = version
    ENV["GROOVY_SSH_VERSION"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    assert_match "groovy-ssh-#{version}", shell_output("#{bin}/gssh --version")
  end
end
