class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      :tag      => "v0.16.0",
      :revision => "702c267fc3d486f1ab9709ffc0d31935be3375dc"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fef874f4dbb3cfad0cb30d79e67f63d3481880f0e18dd0a67d20cb6810fd52a4" => :mojave
    sha256 "c168f9646b98d662ec91251aeeabe3332e11085088fecbae688cf0b0973ced22" => :high_sierra
    sha256 "f0aeffd502d844aa8aae19fdfe8b4db1ce46dc43890b8a5ddeab4dc4606cfacb" => :sierra
    sha256 "5bf5fcfbf8931b1a07fb8a21dda2e3dc3f73cfe0cc8aee85f25eee0ecabd8ac4" => :el_capitan
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
