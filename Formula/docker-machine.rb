class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      :tag => "v0.11.0",
      :revision => "5b274558ea6ca822c06dd407a4e774a0105c3f60"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db6d130c6b73e6112d01a546e1dd7dffee25daf7a53a9b672b65a5b651ff6a18" => :sierra
    sha256 "59db64fa08b28342bdf96066787889a3e9fd9d21c2a78b2ff2bbe24df8e68281" => :el_capitan
    sha256 "8e843093e41414c0c8d50b3725ad3fe92a525e9bfebbb44949cd2fcef60360a9" => :yosemite
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
