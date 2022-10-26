class ArmCli < Formula
  desc "Armory ARM CLI"
  homepage "https://github.com/armory-io/arm/"
  url "https://github.com/armory-io/arm/releases/download/2.3.0/arm-2.3.0-macos-arm64.zip"
  sha256 "c34c1d9a8ca92b2a449412680198d23d4b50ca08fd97ae7a0afaa49113a129b9"
  license "Apache-2.0"

  def install
    bin.install "arm-2.3.0-darwin-arm64" => "arm"
  end

  test do
    run_output = shell_output("#{bin}/arm 2>&1")
    assert_match "The Armory Platform CLI", run_output

    version_output = shell_output("#{bin}/arm version 2>&1")
    assert_match "rainmaker", version_output
  end
end
