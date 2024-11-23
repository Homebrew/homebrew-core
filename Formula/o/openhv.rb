class Openhv < Formula
  desc "Pixelart Science-Fiction Real-Time-Strategy game"
  homepage "https://www.openhv.net"
  url "https://github.com/OpenHV/OpenHV.git",
      tag:      "20230917",
      revision: "7943e1a7529ed6741479ddb75f6514041ed9ab6c"
  license "GPL-3.0-or-later"
  head "https://github.com/OpenHV/OpenHV.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "dotnet"

  uses_from_macos "curl"

  def install
    ENV["DOTNET_NOLOGO"] = "true"
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"
    ENV.deparallelize
    system "make", "all"
    system "make", "version"
    system "make", "prefix=#{prefix}", "install-assemblies"
    system "make", "prefix=#{prefix}", "install-executables"
    system "make", "prefix=#{prefix}", "install-data"
  end

  test do
    system "#{bin}/openhv-utility", "--check-missing-sprites"
    system "#{bin}/openhv-utility", "--check-yaml"
  end
end
