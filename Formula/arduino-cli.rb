class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/0.5.0.tar.gz"
  sha256 "17832841c36a46a8cdf1f03c29843ab805721a11df6f5f1bdd82e1df43304717"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/Documents/Arduino/test_sketch")
  end
end
