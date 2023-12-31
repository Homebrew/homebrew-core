class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/refs/tags/2.11.2.tar.gz"
  sha256 "0e078b37fe1ba1a9ca7191e706818e3b423588cac55484dda82dbbd1cdfe0b24"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5df720161be7b88a9d435b2d4c9dd4e272276d7bda2e392557d66f786e87ef2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f41326acf59721dae0fc14baeef1376c612e69c76da7ee98a5a0e1bf18a40f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "722ed5d7f34c34748e9274532cd33774e236d518e58721d1ea16d0437222c8bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "17bf11543620bed24a77117f094ec31e73f2c212e1199aeb9fa62aaf2e86983a"
    sha256 cellar: :any_skip_relocation, ventura:        "2ce761546a64ae522a633bc13c7389c5a5fbed193d613c5c173a11a72833081e"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7f800d753e98a29e99c85c22a876fc7090e853d1e73fcf4821fd7bd8fbfa88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "926f16eaf21cd5fa5971a238c95a06f5ccccccf340207a5dd3951f16a42c1ec5"
  end

  depends_on "gradle@7" => :build
  depends_on "openjdk"

  def install
    ENV["CIRCLE_TAG"] = version
    ENV["GROOVY_SSH_VERSION"] = version
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    assert_match "groovy-ssh-#{version}", shell_output("#{bin}/gssh --version")
  end
end
