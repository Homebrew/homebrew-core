class Infrakit < Formula
  desc "Toolkit for creating and managing declarative infrastructure"
  homepage "https://github.com/docker/infrakit"
  url "https://github.com/docker/infrakit.git",
      :tag      => "v0.5",
      :revision => "3d2670e484176ce474d4b3d171994ceea7054c02"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9347d93e45e1a259e189ee9a2740cfa0c02d3ca681df4ba22b09b0e5b53821" => :mojave
    sha256 "577be79865b3ee5eb331fc80e79112e71110b2c2a34887a4efb43ac5fa0ac67f" => :high_sierra
    sha256 "46da3285072da2574ed804c2c243b377f794642ea280744abd7e91fed5577048" => :sierra
    sha256 "b4581c8bf2de6220369a79ab9928ee09cf43038dc6c03169416a13a959de3ffd" => :el_capitan
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
