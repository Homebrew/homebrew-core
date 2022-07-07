class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "5b65d784a66b6e7aa7e6bc427e2886435747cb9b2969f239d3be1f2190929fe7"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f371b1ec3e25cd932a0e00d3a7516657404fcdb9fc21889c87ed5fb50631864c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "291d7304de8ee426058e81e8bebccbb01be6e425619fe19498b24adffd679043"
    sha256 cellar: :any_skip_relocation, monterey:       "1a6b75b713f70f8cbadc26189d4ebd3f7343cefe4c2d5291caaa6469398af614"
    sha256 cellar: :any_skip_relocation, big_sur:        "53be472cdfa52204313a02b8e5f05b25130439bf163cd9b15f0b1548159f6249"
    sha256 cellar: :any_skip_relocation, catalina:       "bc7f30f306e1bb6a883a6ad2906370102d81ce3eb4abcf5f80f576c2d8fc2d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9db457c857b9c2cf459ab3982a32e3140f9675fd91d6fdf0a56ea6d48f2bfa"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki", java_version: "11"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
