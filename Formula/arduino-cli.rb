class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli/archive/0.3.4-alpha.preview.tar.gz"
  version "0.3.4-alpha"
  sha256 "5ef20b59f27dc8ebeb6e3c6cd854ce3dd79fe2900189ea9bd8b4272ef83defb4"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/arduino/arduino-cli").install buildpath.children

    cd "src/github.com/arduino/arduino-cli" do
      system "go", "build", "-o", bin/"arduino-cli"
      prefix.install_metafiles
    end
  end

  test do
    config = File.open("#{bin}/.cli-config.yml", "w")
    config.write <<~EOS
    - paths:
      - sketchbook_path: #{testpath}
    EOS
    system "#{bin}/arduino-cli sketch new --debug TestSketch"
    code = File.open(testpath"/TestSketch/TestSketch.ino", "rb")
    assert_equal "void setup() {
}

void loop() {
}
", code
  end
end
