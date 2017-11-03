class Grakn < Formula
  desc "The Database for AI"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v0.17.0/grakn-dist-0.17.0.tar.gz"
  sha256 "27d41b82ea6144af149ed09ab4631501bb2beaea7b94e28f4b1fc4cca0443434"

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
