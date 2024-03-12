class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "3c36734cdf13a2751ad69c1364a49359a34db31f1544cc4ee9b81ec2d481ccb6"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "774070ee72a873d644f81e10f10093f1a7d6c0b7870f05c0714f3bffa2e3a82c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "995170b11604128a7e3c8e5c0cf968130a07b70274606cb35df96e25755d5aa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8577fb915ec790efb9f7f7f3ef8d768853864f606a781c951a47f23892f0c0cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "dca2bc69111b7c93ad93e0ba7bcbdc317753476077fc68721d9ed9e2adec3849"
    sha256 cellar: :any_skip_relocation, ventura:        "ee67de6e2684e07e863978b9434ba2f3ab2ba538812877a54c8b70740fc8d5dd"
    sha256 cellar: :any_skip_relocation, monterey:       "5c4ecaf9040fc885152e0ede928f26e73bf5568c1b08f1fca57ba76304e1208f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c57b46eb9704c162318971d387cbd99b91eb6d82375d32878f62d1abf5a1c9"
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
