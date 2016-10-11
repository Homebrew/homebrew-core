class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data."
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/nifi/1.0.0/nifi-1.0.0-bin.tar.gz"
  sha256 "2b06f389b5e328614e0e2c7add22e6e192917a9e375aa0798835552c670923a8"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]

    ENV["NIFI_HOME"] = libexec

    bin.install libexec/"bin/nifi.sh" => "nifi"
    bin.env_script_all_files libexec/"bin/", :NIFI_HOME => libexec
  end

  test do
    system bin/"nifi", "status"
  end
end
