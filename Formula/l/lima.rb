class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "5dfd2d6010457bc9e3c255cffa26ffd0aea193f7806afb46cc15afe3e2a5b352"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ede95492c219342fbdac1162e2e4a66f8bafcced196f9fff913fd698e943c209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39fdb41f25f051a1f68ddb3fdea6a39aad3a933d60216c5327fb4698036f87ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2638faf1a2dafa214429dfcbbb87d9212db9f16221fc7a905cac2483c6c9a900"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1692f91f8f45a78b157fcb3723f402171d7c7d576cd8f92104f016e5e938b66"
    sha256 cellar: :any_skip_relocation, ventura:       "1e374aeae488f0ced815e76d8d3c07d07c97471e51cad30db7fe5746d8fc6f1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3c0c7867e3ccbdc97c33b968fc1f800258ec177d55d9476024622cfd7222563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a48eda725b7eed5027ed7934a51c692991485d588fa0ddaa18d6a25481bf2f77"
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
