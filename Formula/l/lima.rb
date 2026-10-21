class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "d551efb52115ba006c1052d5c929e4d3afac363c78c9cfca6975af1f85c1426a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45b60082bc96dca12d076e75b9b0651edc3df86861de855d724ffa47fd2173ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb28334f31cc05f6a1d1fdaa282e97d3fa9908cf97d2efa3c95b08e28ad177b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47a100808049a4d9903d94f69c00ae74e4548fa3c3073a8aa70b847891de735b"
    sha256 cellar: :any,                 arm64_linux:       "3f0df0d72c8b68993d47fa406ca8d3197ae56f166837c5543479459fa504638e"
    sha256 cellar: :any,                 x86_64_linux:      "cdff168d449ec581ae16f966d7eaac07a945ef8c58434f8531a5aa54d15f0f30"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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
    generate_completions_from_executable(bin/"limactl", shell_parameter_format: :cobra)
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
