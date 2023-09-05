class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.11.2.tar.gz"
  sha256 "0e078b37fe1ba1a9ca7191e706818e3b423588cac55484dda82dbbd1cdfe0b24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e5c10ea739e816aecf3c7db36673c3b28d016a9c8cd24d102223f0044170474"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f63dfca6ad3c9db36050d581582b87357b9483e7117e5dc851fd7a641ce8e454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca925dbbc301b24f163061017b455e5a076ba20a3a0e7dc90cfe1b04c488a4f9"
    sha256 cellar: :any_skip_relocation, ventura:        "7435236d8601e27ec7a71843a972ac31acc61be595e94235dd12a8229c89b4f9"
    sha256 cellar: :any_skip_relocation, monterey:       "7bc677e68b78169c7f0cb92305fbb176250c97a68bbb1606d77c365aa1384c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8b2cdae040ff2a37ba7df91b5ba9b292633df0656791fc7617585300b8bdb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d4ded31d059a3d36f783aad5ed1fd48a2b7638b93b7d987f51bbbbb3daf8d3"
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
