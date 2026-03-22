class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "9358f4629ba01a5998327017be0470fff914b5f1bf902bbd2616ec520074ec78"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ec266c841f4f00c1436e648c23880dda8299ae7f151db2da7487bfcaa99cb6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e385d20f4b9153f8f225068d797381832521fd124205a9cd52de1073592799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caca6b3d6a0e627e9ada395e2c59105709c43cc76c6d1088e5864986c9738de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e17caff2d3ee98a26731a2914f8372a7de87d6c220e1b62b0553f93ca2deec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4531281e8af626b64f9275a4de472eb9b068826404ebe4309fbb15fec0193101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe3f77f41e5beab26cc9ec4421e455655e2b2ccbccfa29a3219fbe0b2ec6767"
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
