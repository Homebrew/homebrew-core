class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8d98889affd190068022b4596a34b0a749a9f41f340b9b55cefd7591cf30bbbb"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f99ea39cfe538e790b9dd1877c58f1a779324be427e287f288a6909c4a7f0f04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0f6fe33566069289518680dfe58a4488ad03bacb30edbeec3c75f9d62ecb707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "577b9a4bdc83f4d52dc2f556daef6d2f8a4a38d8c168a8e61f07f1b6b14f4ac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e6c9ca5131d4961826100369abd78fd97c513cb5cda66e0f9b2801e248c4841"
    sha256 cellar: :any_skip_relocation, sonoma:        "987df34a6ffc46d752c0c146f6a1130dd91d7299cb3ff175b8edfe3da8cc5c5d"
    sha256 cellar: :any_skip_relocation, ventura:       "9b8c8d588c824b5b26e02a79dca5e64a1db3d428d003b830aaaaa1c3c22e68c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a48a6373589db1ff2f1ea139f853d7b5ece4dc7b8dc0d4741b4868d700d9a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b865114b961820b339f908eeb7cfcc9e48f03b9c4aba3e2169511cd5c7ca7155"
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
