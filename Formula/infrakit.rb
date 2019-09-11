class Infrakit < Formula
  desc "Toolkit for creating and managing declarative infrastructure"
  homepage "https://github.com/docker/deploykit"
  url "https://github.com/docker/deploykit.git",
      :tag      => "v0.5",
      :revision => "3d2670e484176ce474d4b3d171994ceea7054c02"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a20e2268d7d92cb9fcdb136c0940a7bfa62faf6bdc33f79f89639bc08e7d7cb1" => :mojave
    sha256 "3d188727e1be0bdf150e152b0939560a209415fa9d3b5c2275eea163510d4994" => :high_sierra
    sha256 "8db80c4d2d7842486a4cedfa4952ed06e453f2e61f4e6818a08b17fa694d1a1c" => :sierra
  end

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
