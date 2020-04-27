class OrkaCli < Formula
  desc "Tools for accessing the Orka service. CI/CD integrations for Orka"
  homepage "https://www.macstadium.com/orka"
  url "https://uc9cb75a895f6874bc7c45d4b87d.dl.dropboxusercontent.com/cd/0/get/A2p9iOqaIfvVKC0nyh_X584y4vqqJpBHdwXBqaSDcM5CCWCdMfSPHhtd9Tf4MdLQRgjZC0Yor5c-6QNfik88Kxy58s2ROVNczcfRdo3soRtMaRMykL4j4HOeiPEmmte3Y_c/file"
  version "1.1.0"
  sha256 "1899e2ece05ee7e83b6e360e5d42cef063e57a70c7e48030cfb35935f73954da"

  def install
    mv "orka-cli-macos", "orka"
    bin.install "orka"
    executable = bin/"orka"
    executable.chmod 0755
  end

  test do
    system "#{bin}/orka"
  end
end
