class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data."
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/nifi/1.3.0/nifi-1.3.0-bin.tar.gz"
  sha256 "f44407e86b370fe4851188100a7e9ae0b3eb347e6ffc78ae65208c0f59c1410e"

  bottle :unneeded

  depends_on :java => "1.8+"

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
