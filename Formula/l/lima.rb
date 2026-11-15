class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "436ace830cb3e8fa512e0157a220bd8d6f826aef789c3f26d2984f0ea1e3c2ea"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63c44cb5e32dbc42f0bceab7a1333c8e0886c8e57b8d6dc9dee866821e97295d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31d56468c1ea24705ebe1a195a7b6cb8953031ebcf14beb9b979e2a50326092f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c50b922d11d6d9b3ca799bca38f185600c9d6c662ad3516e15759f4514e2789a"
    sha256 cellar: :any,                 arm64_linux:       "a3bc70a857b819a2d8859a1d546b1e637b46f4f656f7afeb7079be83183bb94f"
    sha256 cellar: :any,                 x86_64_linux:      "459669b880f99bead05dbca871db42143d66c380c1b920c0f33d5c280aa65803"
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
