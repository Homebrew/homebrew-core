class Infrakit < Formula
  desc "Toolkit for creating and managing declarative infrastructure"
  homepage "https://github.com/docker/infrakit"
  url "https://github.com/docker/infrakit.git",
      :tag => "v0.5",
      :revision => "3d2670e484176ce474d4b3d171994ceea7054c02"

  depends_on "go" => :build
  depends_on "libvirt" => :build

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
    ENV["INFRAKIT_HOME"] = testpath
    ENV["INFRAKIT_CLI_DIR"] = testpath
    assert_match revision.to_s, shell_output("#{bin}/infrakit version")
  end
end
