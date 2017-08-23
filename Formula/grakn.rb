class Grakn < Formula
  desc "The Database for AI"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v0.16.0/grakn-dist-0.16.0.tar.gz"
  sha256 "1c7194f09cbf31949323b79b2fb8a5683381af5ecf37886fd45deb71585261ed"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :CASSANDRA_HOME => ENV["CASSANDRA_HOME"])
  end

  test do
    assert_match /stopped/i, shell_output("#{bin}/grakn.sh status")
  end
end
