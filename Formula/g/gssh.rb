class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://gradle-ssh-plugin.github.io/"
  url "https://github.com/int128/groovy-ssh/archive/refs/tags/2.12.0.tar.gz"
  sha256 "b2ce4ddc0d208e90ab4e986a1b1d759955783bdf3fe046f770eba98e6e6a13a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a553584f7cf8db8128678eb9cfaa533d5ded948f46ebc7ca9ed4fc0a0f52731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6811a36ed6d1d50a0128cfcbe2d49d1e58e42f5f8f19a77f7e01dc559f6da7a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e78ac9c48bc0993ba4f7f668a3843bfc68156857267809e14b6536ddcb389fde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "827e8749626bd62fe6bbaefd247dffe3ccdc6562898a921af2f5839d4b842477"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2837254b95e0d2ee0eeda3f0baaca1afff32499a5a49fcfae5be9b4903068cd"
    sha256 cellar: :any_skip_relocation, ventura:       "5dd2bfab32371162fe7f5c1af5ffa917c0d3d33188b53656df6be5e404751994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff58b3274940f9598bf67f133d1a3e7e0d8370ff958a3b6989755918e47da34e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4756849c57e1ad9a7cc292f65c4ea7d10ee2a2b6ba3cca7c411d07e85bb5eed5"
  end

  deprecate! date: "2025-05-25", because: :repo_archived

  depends_on "gradle@8" => :build
  depends_on "openjdk@21"

  def install
    ENV["CIRCLE_TAG"] = version
    ENV["GROOVY_SSH_VERSION"] = version
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh", java_version: "21"
  end

  test do
    assert_match "groovy-ssh-#{version}", shell_output("#{bin}/gssh --version")
  end
end
