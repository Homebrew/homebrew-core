class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      :tag      => "v0.16.0",
      :revision => "702c267fc3d486f1ab9709ffc0d31935be3375dc"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aec00d16a4a501a17247b170739f23e66f0c86a3d0543bc65419bf4463b2431" => :mojave
    sha256 "610bce22171388ef9b801c3ce0be160c00bc460679c69d44d30017b8d9c3a1c0" => :high_sierra
    sha256 "6a9fcbd3b3ce85a2206bfa991407a507e1da496b060a9f07ff589f256d80d324" => :sierra
  end

  depends_on "automake" => :build
  depends_on "go" => :build

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

  def plist
    <<~EOS
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
