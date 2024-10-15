class Ogc < Formula
  desc "ogc"
  homepage "https://github.com/songant/open-gpu-cloud"
  version "0.0.1"
  license "Apache-2.0"

  if Hardware::CPU.intel?
    url "https://github.com/songant/open-gpu-cloud/releases/download/ogc-cli-1.0.0/ogc_cli-darwin_amd64.tar.gz"
    sha256 "79ec9313ec9d722a7bd59673fab734b11ec73399270b667c1dda947a04082227"
  elsif Hardware::CPU.arm?
    url "https://github.com/songant/open-gpu-cloud/releases/download/ogc-cli-1.0.0/ogc_cli-darwin_arm64.tar.gz"
    sha256 "0df55a219befc878db2ae362bab07c4bc35f03d7630735087bec7a4e8c597602"
  else
    odie "Unsupported CPU architecture"
  end

    def install
    bin.install "ogc" => "ogc"
    system "xattr", "-c", "#{bin}/ogc"
    end

    test do
      assert_match version.to_s, shell_output("#{bin}/ogc --version")
    end
end