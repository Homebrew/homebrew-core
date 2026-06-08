class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "23fa5f4621e355236a10200c4e4f61eae9f69c805c57a107247847b51522ab8a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b762e573046db099d16a730ac5b0561ad61b823a337d73c0528750ca2d4f9bd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcda869caf799be40a9b22b00a4f109cb2e9a50e95340eb4f77e9198d4e4c45e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93bc48f6d86f1a4d78601e2d5a7e1736e9ad4a4fd14337b9996dec2926e47fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e3b4b0f51cb5a08467b6eada8bf23fae67c967ea25c11170c4b6704a885d5da"
    sha256 cellar: :any,                 arm64_linux:   "2c2440995c7ae53ca76494f96f926c70ade7332ede2755b0c96209596b47a4a5"
    sha256 cellar: :any,                 x86_64_linux:  "80fe13c85ee20db766fd1f5cfcc7e10a393df7924f379cfd9c49fac39e041390"
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
