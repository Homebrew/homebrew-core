class Namebench < Formula
  desc "DNS benchmark utility"
  homepage "https://code.google.com/archive/p/namebench/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/namebench/namebench-1.3.1-source.tgz"
  sha256 "30ccf9e870c1174c6bf02fca488f62bba280203a0b1e8e4d26f3756e1a5b9425"

  bottle do
    cellar :any_skip_relocation
    sha256 "35225323dc77dc1954cd19b1aa0476e4ebab47e91dbabbfc7e169b5b500b0eba" => :mojave
    sha256 "4c2312daef0aae052b7e65bdb4b20cdcf1bfa601e5f8a484a7f846be1096bcb1" => :high_sierra
    sha256 "ae766151284842185ceecf1622a82cf55c949994729536015a42eea38f62309c" => :sierra
    sha256 "3333ef2615f6fbf294cede389d8545487474779a52c18108feb83a4697530cdc" => :el_capitan
    sha256 "8d400aed171038f248e9d91718fb42625fc1f278df538b34259f26918b245f66" => :yosemite
    sha256 "ac3d993b71305c18b47fa671ecb4c5875b80fd7ea87a6fff0f123c3c2cfdcb43" => :mavericks
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}",
                     "--install-data=#{libexec}/lib/python2.7/site-packages"

    bin.install "namebench.py" => "namebench"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"namebench", "--query_count", "1", "--only", "8.8.8.8"
  end
end
