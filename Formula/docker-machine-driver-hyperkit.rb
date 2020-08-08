class DockerMachineDriverHyperkit < Formula
  desc "Docker Machine driver for hyperkit"
  homepage "https://github.com/machine-drivers/docker-machine-driver-hyperkit"
  url "https://github.com/machine-drivers/docker-machine-driver-hyperkit.git",
      tag:      "v1.0.0",
      revision: "88bae774eacefa283ef549f6ea6bc202d97ca07a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "970f9a0f226f1dde7d60e0878a05cef43b503e79f669e2f69fa6e2fd48cfb7f5" => :catalina
    sha256 "1b3ba8ce6ae05b27463ef2b8ebfbdeec911a0b6f1ba20188279b79dac81b4754" => :mojave
    sha256 "41aecb9ebaf6d8b45780cef4acd16a3b40b4e6be0020d1aae8a68d4d314adeda" => :high_sierra
    sha256 "4cdd1e0ed1b3d36dc19b31ad22d1f03578221504ce4c731ba30c0179f2c1ee00" => :sierra
    sha256 "92bef33ec9ad5fbdfb887fcabe550603c886065c8ec3c677732a55f84a4c7520" => :el_capitan
  end

  head do
    url "https://github.com/machine-drivers/docker-machine-driver-hyperkit.git",
      { revision: "c72f8ba7a45adae0acf737e5e89b8e7c4710e1c8" }
    # To make it usable in Catalina
    # All commits in https://github.com/machine-drivers/docker-machine-driver-hyperkit/pull/14
    if MacOS.version == :catalina
      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/01bd201436fe273723c034a43551db85227e67d2.diff?full_index=1"
        sha256 "dfe4e4a80dcc423bdc29bae29b1af301c3a90883643e0e66144926c5c3eb80ba"
      end

      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/244411c5f2b8281be29b7107c6cba115f65e5345.diff?full_index=1"
        sha256 "87a926937f768c60d57ac0f66a4e90bb921c1f88f38030550b88d25848435f4c"
      end

      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/18a3d7e448e20501151b1865599816c691898c45.diff?full_index=1"
        sha256 "46f672a32b270776528875b65c9b669eef97fc88568e375adb139b3642b5fb67"
      end

      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/d6466b05deef689b0829b8b567eb25879464b215.diff?full_index=1"
        sha256 "6f693c0b599e3b6244e8e6ff2224ec53c6b86815aed7c7debfd65dc9d17a7368"
      end

      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/2258b9420360074164abca30f7502220cab1988d.diff?full_index=1"
        sha256 "241d465d10918a8351cc777d5e9c6fb366d75aa07e56f72ba641de02ffd7bf23"
      end

      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/1582e49a95c203da5700a82a268471765db3b231.diff?full_index=1"
        sha256 "512d1f5cad8e54cdc61cd0bdc662514da3bc60f1a972ff460dc73bcf5f3905be"
      end

      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/0109dc5a45c0682b4ea24aa8094a8b6cc420acc1.diff?full_index=1"
        sha256 "8707da9c0437067939ecd3aa7c15f9d8c488182550b0051fd9942b9a19c71914"
      end

      patch do
        url "https://github.com/machine-drivers/docker-machine-driver-hyperkit/commit/46602b1a40bccdbfecebef3ceebf532b76e5506e.diff?full_index=1"
        sha256 "7b5b48703d1d345af900c8a3a791c5667757f9a173610067bb15c1c457cd7c15"
      end
    end
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/machine-drivers/docker-machine-driver-hyperkit"
    dir.install buildpath.children

    cd dir do
      # To make it usable in Catalina
      system "dep", "ensure" if build.head? && MacOS.version == :catalina
      system "dep", "ensure", "-vendor-only"
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
