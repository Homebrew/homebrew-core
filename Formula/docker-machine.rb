class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      :tag => "v0.8.1",
      :revision => "41b3b253352b8b355d668f5e12b5f329f88c3482"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b1c0935805ecaa6e3231205e27e113cb01a875b9f9b4d5ae61ef0118a6c18c04" => :sierra
    sha256 "c5dbdfb0613c9ee47bc076afd6c891a03da324827fba76333f2fbfd11f6e28c5" => :el_capitan
    sha256 "125b5fa1cf19348bf9c1c7cb0ebf81b355dc88eab86ec03eb2c45cee6c31a35f" => :yosemite
    sha256 "5ecd239dcbabad6e5d5b1ffaf06b704070158edd2890e560de132ada5d1e3817" => :mavericks
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
