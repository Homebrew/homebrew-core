class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "55625e642de492827e6cf7740c095822ef8193458211e286f17a3c11ebf50a93"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c09127136956dd84a90626bf0da8a61ba27034cefb44f907467a15e85747a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8413f1a4345b6d4d09491f34b31743db5c127e4b5be09e94aea254978cfd647d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15b4bb67026a8ece6a67c964c7ef3876f56fa984cc770d410ad07dec888486d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2df3eb5de5aa4c29b3045562ab5d1a4f475cbed1b7b32ad4ac6a5a37c9483580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e395abb2679e126b217c5ad8803732429229da8ba1e2a7716e21ab4ace4757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16c98fca4ff0deae01d3ad5d13c013ebcc7012232a6f80228a83b4ccbe8bd90"
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
