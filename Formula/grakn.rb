class Grakn < Formula
  desc "The Database for AI"
  homepage "https://grakn.ai"
  url "https://github.com/graknlabs/grakn/releases/download/v0.15.0/grakn-dist-0.15.0.tar.gz"
  sha256 "010294b7d8f59e685efed2024132e49b31563b052351a91e2bf1ff75269b7052"

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
