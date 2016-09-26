require "language/go"

class Boot2docker < Formula
  desc "Lightweight Linux for Docker"
  homepage "https://github.com/boot2docker/boot2docker-cli"
  # Boot2docker and docker are generally updated at the same time.
  # Please update the version of docker too
  url "https://github.com/boot2docker/boot2docker-cli.git",
      :tag => "v1.8.0",
      :revision => "9a2606673efcfa282fb64a5a5c9e1b2f89d86fb4"
  revision 1

  head "https://github.com/boot2docker/boot2docker-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dfb9853a87594fde5243295f959f70625db43b0fa4ebd95f1d43e8e8981488ce" => :sierra
    sha256 "557a4c650af0733d298eb68cdd10d192944841e1cea57a9ac2abb1346b79c88f" => :el_capitan
    sha256 "d994acb53e60099a0cfab0f3261adbda070add67eff32ea05754d3975c14891d" => :yosemite
  end

  depends_on "docker" => :recommended
  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :tag => "v0.2.0",
        :revision => "bbd5bb678321a0d6e58f1099321dfa73391c1b6f"
  end

  go_resource "github.com/ogier/pflag" do
    url "https://github.com/ogier/pflag.git",
        :tag => "v0.0.1",
        :revision => "32a05c62658bd1d7c7e75cbc8195de5d585fde0f"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/boot2docker/boot2docker-cli"
    dir.install Dir[buildpath/"*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd dir do
      # Fix for Go 1.7 argument style preference.
      inreplace "Makefile",
                "-X main.Version $(VERSION) -X main.GitSHA $(GITSHA1)",
                "-X main.Version=$(VERSION) -X main.GitSHA=$(GITSHA1)"
      system "make", "goinstall"
    end

    bin.install "bin/boot2docker-cli" => "boot2docker"
  end

  def caveats; <<-EOS.undent
    Rebuild the VM after an upgrade with:
      boot2docker destroy && boot2docker upgrade
  EOS
  end

  plist_options :manual => "boot2docker up"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/boot2docker</string>
        <string>up</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"boot2docker", "version"
  end
end
