class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/0.5.0-showports.tar.gz"
  version "0.5.0-showports"
  sha256 "96373b59e004f277474eb5a11e2a585633976c9939056b833e65e670e7393e77"
  bottle :unneeded

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/arduino/arduino-cli").install buildpath.children

    cd "src/github.com/arduino/arduino-cli" do
      system "go", "build", "-o", bin/"arduino-cli"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    arduino-cli is an all-in-one solution
    that provides builder, boards/library manager, uploader, discovery
    and many other tools needed to use any Arduino compatible board and platforms.

    type arduino-cli --help to get started
  EOS
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
