class MinifiCpp < Formula
  desc "Subproject of Apache NiFi to collect data where it originates"
  homepage "https://nifi.apache.org/minifi/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=/nifi/nifi-minifi-cpp/0.5.0/nifi-minifi-cpp-0.5.0-bin-darwin.tar.gz"
  sha256 "f3500e69483ef26374b797df84ed531deeea6d474b12af361b9bd05b6ef8d31a"

  bottle :unneeded

  def install
    libexec.install Dir["*"]

    ENV["MINIFI_HOME"] = libexec

    bin.install libexec/"bin/minifi.sh" => "minifi.sh"
    bin.env_script_all_files libexec/"bin/", :MINIFI_HOME => libexec
  end

  test do
    system "#{bin}/minifi.sh", "start"
    system "#{bin}/minifi.sh", "stop"
  end
end
