class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c36e803f4faf41607220df4c1d7a61977a7d492facf03e0b67f1f69390840a90"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5bbdf46683a37bcf7e966c9f5a91f2da620a80b9378f75b575ba32f288f6d5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aeb0a3b7295f0c3e0c2a7a92a798a44397936e5bb732db825aee6da5e762d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80f5e9fb07ed53da6675bb616a02dfd13f394a953cbe0fd5bd28ce3b7b072fe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f675abee28d0f10f335f7a04dc6ad3de12434c83c2f0f32c913061204c137a94"
    sha256 cellar: :any_skip_relocation, ventura:       "fe6dbf00e813c294ba0f1e8dc053d2aa6fbc8db83cdfa50ace2d81c5fe5e3346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ebdca67c4a83677827fab4b7bc393e3201ed5d807d5095a702c8977eb83debd"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

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
    generate_completions_from_executable(bin/"limactl", "completion")
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
