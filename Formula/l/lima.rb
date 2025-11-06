class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "7eb0fa9caa6b8f09548cc2c45603c6fb50eb0a34a8c3b57d6d42c3a8aeba81b7"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d9fe181a6dd1e019e24216aaaa15c88791598d7d23621f56a56345d425c5ad6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4214fdc16f886f7054c39ae85819ccde5080efba083006565503a4349f7c36e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091c535e72c639e3a5acc9d0cc6520a3eb9b2edbe883e54d3fdee4a37df4706e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e103dad6cb82d59d9f7b6f3c2d8219863c0e48e650da5acd71460e4a2ce3242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7594b0a496f9a1b0e994ffc414662c969d10cb6a6d565747ed3409644421ca75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627b3697f9c72c9261cff35b9fc5e01f32b630c5b2872ca5f19862e529901118"
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
