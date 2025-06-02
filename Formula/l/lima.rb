class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "82577e2223dc0ba06ea5aac539ab836e1724cdd0440d800e47c8b7d0f23d7de5"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cd1a319ae657c32218da384ab05a8de1af594b5b298687ab5f0082a4bae570f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef3da306aebcec4125f01376855bc422e629375914866217206f4b84cb05f17c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae4f6f583bcfac4cd65d0a5a435f029fcad07c912001b34b69c4b86989f8a1a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c45416f1811568ee8800d55440e281a223b06bdc43783eddf361d118213b4b4c"
    sha256 cellar: :any_skip_relocation, ventura:       "f41f7371692a2d18cb3068fb49d63e00c26a24cd7d99458eab6678d972bccbdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e81a7100ebccbd85fda8c6de1908cb8930cd5c51443532c167b90b4325f09af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f62f734e16c2d4bbe15acb813acffba55c25fa1e378d4c3763c7c184470fcd50"
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
