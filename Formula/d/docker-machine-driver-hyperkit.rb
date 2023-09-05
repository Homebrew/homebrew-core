class DockerMachineDriverHyperkit < Formula
  desc "Docker Machine driver for hyperkit"
  homepage "https://github.com/machine-drivers/docker-machine-driver-hyperkit"
  url "https://github.com/machine-drivers/docker-machine-driver-hyperkit.git",
      tag:      "v1.0.0",
      revision: "88bae774eacefa283ef549f6ea6bc202d97ca07a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7eddab300d15e5780d7ec4e948ef42c27a463e1bb5b8e0b51bfe0cf92616c1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfcf7e911428a0d3e3c744f548dbe7aeb54ebc2bdf4fa7d0e20b3101befdeb74"
    sha256 cellar: :any_skip_relocation, monterey:       "eac641545c996d7f96c0823320fbe96ec3b11d409a65ad2e638cb6d05ab7daf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "aceb28bcaeef7df607301f44b3f27d63349e178770e7d7e50543b3e6254c58e7"
    sha256 cellar: :any_skip_relocation, catalina:       "970f9a0f226f1dde7d60e0878a05cef43b503e79f669e2f69fa6e2fd48cfb7f5"
    sha256 cellar: :any_skip_relocation, mojave:         "1b3ba8ce6ae05b27463ef2b8ebfbdeec911a0b6f1ba20188279b79dac81b4754"
    sha256 cellar: :any_skip_relocation, high_sierra:    "41aecb9ebaf6d8b45780cef4acd16a3b40b4e6be0020d1aae8a68d4d314adeda"
    sha256 cellar: :any_skip_relocation, sierra:         "4cdd1e0ed1b3d36dc19b31ad22d1f03578221504ce4c731ba30c0179f2c1ee00"
    sha256 cellar: :any_skip_relocation, el_capitan:     "92bef33ec9ad5fbdfb887fcabe550603c886065c8ec3c677732a55f84a4c7520"
  end

  disable! date: "2022-09-14", because: :unmaintained

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    dir = buildpath/"src/github.com/machine-drivers/docker-machine-driver-hyperkit"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "init", "github.com/machine-drivers/docker-machine-driver-hyperkit"
      system "go", "mod", "tidy"
      system "go", "build", "-o", "#{bin}/docker-machine-driver-hyperkit",
             "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  def caveats
    <<~EOS
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
