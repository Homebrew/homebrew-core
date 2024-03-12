class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "3c36734cdf13a2751ad69c1364a49359a34db31f1544cc4ee9b81ec2d481ccb6"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51d5a46f73b7109cf2e7a027f43e65c2279c5db3de28e00e6357c83f7b71755a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524812542d0d08025229c2d1eb6f054bcba2cec07c828caa03d6e29ab7a86a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d05720896d79a48d7989dd807082cc8256025d59de617371ed3d16997089164e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e800b3a8587dfdc7fa9dc26fc055ebf69811a3c83eb987b20bf59b59e180eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "bf4f2fe84d192b6d790b57276d99754c2e728eb256add7ef713c311665392482"
    sha256 cellar: :any_skip_relocation, monterey:       "a67dcb6cd9b4dec4e5ad57cf559624d5a27856edd5eb3e7c336ffbcacc255c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc192e7d11403fb188abf9e6c203b92a88b6325247034f378d3b3cfabcfaa09"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    if build.head?
      system "make"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
  end

  test do
    info = JSON.parse shell_output("#{bin}/limactl info")
    # Verify that the VM drivers are compiled in
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if OS.mac? && MacOS.version >= :ventura
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end
