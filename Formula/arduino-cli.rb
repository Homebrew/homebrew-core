class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.5.0",
     :revision => "3be22875e27f220350d8ab5b13403d804acfd20b"
  head "https://github.com/arduino/arduino-cli.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/arduino/arduino-cli").install buildpath.children
    cd "src/github.com/arduino/arduino-cli" do
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags", "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} -X github.com/arduino/arduino-cli/version.commit=#{commit}", "-o", bin/"arduino-cli"
    prefix.install_metafiles
      end
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/Documents/Arduino/test_sketch")
  end
end
