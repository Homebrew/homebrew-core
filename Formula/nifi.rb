class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "http://mirror.cc.columbia.edu/pub/software/apache/nifi/1.11.1/nifi-1.11.1-bin.tar.gz"
  sha256 "b0b35a9db0e6c8c299ca174e668acf8389488976b1674f08771f9361d884c5f3"

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
