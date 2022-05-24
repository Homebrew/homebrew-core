class ApacheCtakes < Formula
  desc "NLP system for extraction of information from EMR clinical text"
  homepage "https://ctakes.apache.org"
  url "https://dlcdn.apache.org//ctakes/ctakes-4.0.0.1/apache-ctakes-4.0.0.1-bin.tar.gz"
  sha256 "f741016e3755054876f3bb27f916a8008af27175ef33785638a6292d300c972e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4c6af60f27e2795e09763b88aa81e00faa80ba6d46e6f6cac3d2cd0b72b9f69f"
  end

  deprecate! date: "2021-12-21", because: "installs binaries and does not build from source"

  depends_on "openjdk"

  def install
    rm Dir["**/*.{bat,cmd}"] + ["bin/ctakes.profile"]
    libexec.install %w[bin config desc lib resources]
    pkgshare.install_symlink libexec/"resources/org/apache/ctakes/examples"

    bin.install Dir["#{libexec}/bin/*.sh"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    piper = pkgshare/"examples/pipeline/HelloWorld.piper"
    note = pkgshare/"examples/notes/dr_nutritious_1.txt"
    output = shell_output("#{bin}/runPiperFile.sh -p #{piper} -i #{note}")
    assert_match "mayo-pos.zip", output
  end
end
