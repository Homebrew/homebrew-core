class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "c1cb9f2a5d35715937bbf21566d58f89fc221ab285a42ddcc30fd6fdaab2c15a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "462f6900e8dc2b6f4390890ca6421773c566fc6b8a550ea83b4a9a048ca1765f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece22d8fbab8b1699fa3cd2cbe2937ca7a1d40c9e61618fefa978a245a98d4e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5918d41acdba805a115daf0b1f5d453c11454d111cc34d42285eea31d082993"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b99753b1837b0b543a2dbc253cbad7ff10a0fb87d52dc44416262f49db58873"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e18e339ebd27059a8ca8910707085c2eab77f66d002f4e19e39cc73bd08aac1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efafb05f8d5813c49215291472c47951ec436711af53ac42d95c826afc2833cd"
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
