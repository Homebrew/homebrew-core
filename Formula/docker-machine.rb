class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      :tag => "v0.8.2",
      :revision => "e18a9193d49de4a45ba4b1b6379cad7775481cd2"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5db131e3232b1e2ccf3358d4ccf6e73666521c04bad9e526f60c61f39e61bf10" => :sierra
    sha256 "b805f69b2a2649ab79bdf8c3d9f49b98b049777dbac77b0a5726327b99706556" => :el_capitan
    sha256 "7dd71c70ddb977bbd3cad40ca66d2223b2ff4528297294b66455312a8fc63b2a" => :yosemite
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/docker/machine").install buildpath.children
    cd "src/github.com/docker/machine" do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
      zsh_completion.install "contrib/completion/zsh/_docker-machine"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "docker-machine start"

  def plist; <<-EOS.undent
     <?xml version="1.0" encoding="UTF-8"?>
     <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
     <plist version="1.0">
       <dict>
         <key>EnvironmentVariables</key>
         <dict>
             <key>PATH</key>
             <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
         </dict>
         <key>Label</key>
         <string>#{plist_name}</string>
         <key>ProgramArguments</key>
         <array>
             <string>#{opt_bin}/docker-machine</string>
             <string>start</string>
             <string>default</string>
         </array>
         <key>RunAtLoad</key>
         <true/>
         <key>WorkingDirectory</key>
         <string>#{HOMEBREW_PREFIX}</string>
       </dict>
     </plist>
     EOS
  end

  test do
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end
