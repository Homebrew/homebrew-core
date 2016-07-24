require "language/go"

class Pup < Formula
  desc "Parse HTML at the command-line"
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
  sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  head "https://github.com/EricChiang/pup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a9ec79a05eeadfb90a35a38a72009ea7deaa7d53e549b6bc4fd99ac99912ed3" => :el_capitan
    sha256 "6453ea102503241bc2290d193831e1f0d6cadf22d801d50eeb885a42400059d6" => :yosemite
    sha256 "9e6e6b1015033619137627ee4b1338ffece6d8f2e67e2cbebaa8a81fa67cc311" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "6e9ee79eab7bb1b84155379b3f94ff9a87b344e4"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ericchiang/pup"
    dir.install buildpath.children

    Language::Go.stage_deps resources, buildpath/"src"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    cd("src/github.com/mitchellh/gox") { system "go", "install" }

    cd dir do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox", "-arch", arch, "-os", "darwin", "./..."
      bin.install "pup_darwin_#{arch}" => "pup"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end
