class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data."
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/nifi/1.1.1/nifi-1.1.1-bin.tar.gz"
  sha256 "afb58050b0904dab329b19b14250b57d3978743a1108323bdc52aba0c2a75853"

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
