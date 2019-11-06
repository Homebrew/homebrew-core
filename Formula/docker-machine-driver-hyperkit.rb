class DockerMachineDriverHyperkit < Formula
  desc "Docker Machine driver for hyperkit"
  homepage "https://github.com/machine-drivers/docker-machine-driver-hyperkit"
  url "https://github.com/machine-drivers/docker-machine-driver-hyperkit.git",
      :tag      => "v1.0.0",
      :revision => "88bae774eacefa283ef549f6ea6bc202d97ca07a"

  bottle do
    cellar :any_skip_relocation
    sha256 "970f9a0f226f1dde7d60e0878a05cef43b503e79f669e2f69fa6e2fd48cfb7f5" => :catalina
    sha256 "1b3ba8ce6ae05b27463ef2b8ebfbdeec911a0b6f1ba20188279b79dac81b4754" => :mojave
    sha256 "41aecb9ebaf6d8b45780cef4acd16a3b40b4e6be0020d1aae8a68d4d314adeda" => :high_sierra
    sha256 "4cdd1e0ed1b3d36dc19b31ad22d1f03578221504ce4c731ba30c0179f2c1ee00" => :sierra
    sha256 "92bef33ec9ad5fbdfb887fcabe550603c886065c8ec3c677732a55f84a4c7520" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "docker-machine"
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/machine-drivers/docker-machine-driver-hyperkit"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "#{bin}/docker-machine-driver-hyperkit",
             "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    This driver requires superuser privileges to access the hypervisor. To
    enable, execute:
      sudo chown root:wheel #{opt_bin}/docker-machine-driver-hyperkit
      sudo chmod u+s #{opt_bin}/docker-machine-driver-hyperkit
  EOS
  end

  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver hyperkit -h")
    assert_match "engine-env", output
  end
end
