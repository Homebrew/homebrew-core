class ApacheCtakes < Formula
  desc "NLP system for extraction of information from EMR clinical text"
  homepage "https://ctakes.apache.org"
  url "https://apache.osuosl.org/ctakes/ctakes-4.0.0/apache-ctakes-4.0.0-bin.tar.gz"
  sha256 "37ca2b8dfe06465469ed1830fbb84dfc7bcc4295e5387d66e90a76ad2a5cdeaf"
  revision 1

  bottle :unneeded

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
