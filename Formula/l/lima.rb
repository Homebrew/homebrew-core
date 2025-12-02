class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "51e0461c719c67c87310a1df4c55afe83f8379c246cd66c1c38773785f7994c8"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "defa0a10a5e8cc7dead80a9c677ecac7b46e2fbf4c10884b5c299a4e6dddf924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c8e8186c915a23e0476283800f5c55b6de47e43fcd84e34105593dc65dc819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a2aae0db4aa6ce8622ee028162f2c05f9453b8e011dc7bf5913b3c475b3bfdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab457ddfb877c61773fd01e878eb9ab49b523657d3fa55058ffc7e232ae58500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ad81031a9b23a70988ad38cb6b007e63f845da127cafc2c6d53ba81486c6d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "791885039d138822b267006cbb3d50ae7e097945dae62d12c22b9f45c649919b"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

  def install
    # make (default):              build everything
    # make native:                 build core + native guest agent
    # make additional-guestagents: build non-native guest agents
    if build.head?
      system "make", "native"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "native", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    libexec.install Dir["_output/libexec/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion")
  end

  def caveats
    # since lima 1.1
    <<~EOS
      The guest agents for non-native architectures are now provided in a separate formula:
        brew install lima-additional-guestagents
    EOS
  end

  test do
    info = JSON.parse shell_output("#{bin}/limactl info")
    # Verify that the VM drivers are compiled in
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if OS.mac?
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end
