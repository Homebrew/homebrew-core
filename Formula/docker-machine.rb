require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
    :tag => "v0.7.0",
    :revision => "a650a404fc3e006fea17b12615266168db79c776"

  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9f7a99dd1cda46e0e795a417d16cbb6daeb92aad5994eb5ed52823287453a271" => :el_capitan
    sha256 "d1fa06ba509240391d27edd626c86184501c23184918f4b646e7b3c9a0e28e15" => :yosemite
    sha256 "b2d0dceb5f7a7e5e39e2e30b91c25f87357be9a24aa1f52254c223009c901be6" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/docker/machine"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

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
    assert_match /#{version}/, shell_output(bin/"docker-machine --version")
  end
end
