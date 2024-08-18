class Accelira < Formula
  desc "Performance testing tool for web applications"
  homepage "https://github.com/accelira/accelira"
  url "https://github.com/accelira/accelira/releases/download/v1.0.0/accelira-v1.0.0.tar.gz"
  sha256 "eebd2e62eab691ad74cd4ab7ea2fa3029f3c4091ea3c5ed02a4a1778534ccdb4"

  def install
    bin.install "accelira"
  end

  test do
    assert_match "Accelira performance testing tool", shell_output("#{bin}/accelira --help")
  end
end
