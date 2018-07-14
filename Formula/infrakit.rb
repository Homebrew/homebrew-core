class Infrakit < Formula
  desc "Toolkit for creating and managing declarative infrastructure"
  homepage "https://github.com/docker/infrakit"
  url "https://github.com/docker/infrakit.git",
      :tag => "v0.5",
      :revision => "3d2670e484176ce474d4b3d171994ceea7054c02"
  head "https://github.com/docker/infrakit.git"

  depends_on "automake" => :build
  depends_on "go" => :build
  depends_on "libvirt" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/docker/infrakit").install buildpath.children
    cd "src/github.com/docker/infrakit" do
      system "make", "cli"
      bin.install "build/infrakit"
      prefix.install_metafiles
    end
  end

  test do
    ENV["INFRAKIT_DIR"] = ENV["HOME"]
    ENV["INFRAKIT_CLI_DIR"] = ENV["HOME"]
    ENV["INFRAKIT_PLUGINS_DIR"] = ENV["HOME"]
    assert_match revision.to_s, shell_output("#{bin}/infrakit version")
  end
end
