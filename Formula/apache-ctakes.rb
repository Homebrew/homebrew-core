class ApacheCtakes < Formula
  desc "NLP system for extraction of information from EMR clinical text"
  homepage "https://ctakes.apache.org"
  url "https://apache.osuosl.org/ctakes/ctakes-4.0.0/apache-ctakes-4.0.0-bin.tar.gz"
  sha256 "37ca2b8dfe06465469ed1830fbb84dfc7bcc4295e5387d66e90a76ad2a5cdeaf"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat", "bin/*.cmd", "bin/ctakes.profile", "bin/ctakes-ytex",
             "libexec/*.bat", "libexec/*.cmd"]
    libexec.install %w[bin config desc lib resources]
    pkgshare.install_symlink libexec/"resources/org/apache/ctakes/examples"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    piper = pkgshare/"examples/pipeline/HelloWorld.piper"
    note = pkgshare/"examples/notes/dr_nutritious_1.txt"
    output = shell_output("#{bin}/runPiperFile.sh -p #{piper} -i #{note}")
    assert_match "mayo-pos.zip", output
  end
end
