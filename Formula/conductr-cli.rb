class ConductrCli < Formula
  desc "The Lightbend ConductR CLI"
  homepage "https://conductr.lightbend.com"
  url "https://bintray.com/lightbend/generic/download_file?file_path=conductr-cli-1.0.1-Mac_OS_X-x86_64.zip"
  version "1.0.1"
  sha256 "fff2d3caa7cbbefc3da4a158b34a46bf51338ae921985cd4fb35d46e3c8eccf2"

  def install
    bin.install Dir["*"]
  end

  test do
  end
end
