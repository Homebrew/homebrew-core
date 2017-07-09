class Grakn < Formula
  desc "The Database for AI"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v0.14.0/grakn-dist-0.14.0.tar.gz"
  sha256 "97b1325d9aa994013b7678e414d0dfee5f0ea165d7ab33867994422e03d1f516"

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
