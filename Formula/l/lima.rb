class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "39209f4f573fc753aea3e95f52713a6432f32f73da5bb60ba913ca46edb1924c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5700d39777426daf59dafdd7afaa34ac29d88ad9c5e4e345929d7cf55410c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37e05a4b243e33004523cec5a8a51ef2e7f67983721ec489eba954770f086ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b130330f16dbdd8293fbe17ae88bbd06d50743c4953fad3f899dc9d74ca4bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9f80a950f9c751ce30d92901aad120e9a7dd735e9c77ad9edbffb10d845d2a7"
    sha256 cellar: :any,                 arm64_linux:   "05fca03f16c68bfa6150f31370e1e53c999ab214ee572488e8b3192495999bcc"
    sha256 cellar: :any,                 x86_64_linux:  "b71817ee5ed9b632f6b4094de0e0232f843ef7f200ebac53f78bb15c2faa734f"
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
