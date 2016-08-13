class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
    :tag => "v0.8.0",
    :revision => "b85aac15463faf0e69f41d757291db9ab4c056f3"

  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55b289e28b0dd64878328583aabab37b5e288d1a5f0d0ffff5df82fb6770670e" => :el_capitan
    sha256 "5a789eafe89f6431fa9250a3664618332c003ed96dc92d571845d35245ced3dd" => :yosemite
    sha256 "8ade6d05a2e293ec09b04475f1f0e41bbe7ab76bac8ae6c8219289daf3a60a9a" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/docker/machine"
    path.install Dir["*"]

    cd path do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
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
