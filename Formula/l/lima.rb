class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "9ea5b439cf71bb8fc4d831c3a71540baaa4c4420152addf1e32de57a4dc8af96"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31c8d1a5164f001587f3f31c23351bba4f8699c0354c21e7f5ec239b03333149"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74698a2b2dd3d9657b90a23230e306fa3a12cb9e449b972d20e6f4e90f4f914a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf98a3ae6bcbe75b0c385abd791c41658ec7bd07b21f1730d32cc4053526b555"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed53b99120ff4e63839cd53619ec4422d18ff2786f728cf3e2dfc7e86d9332e1"
    sha256 cellar: :any_skip_relocation, ventura:        "1739799f0f99bc74173f8f7425d50e682687a8d4b6ea378f214b6b2c89f96f62"
    sha256 cellar: :any_skip_relocation, monterey:       "6c531ca445c9e3f1638a0c357bcb0dbb2e36c555304d1ff290f5bdb6c3ebdfa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b4786360779292403281a97a1e461ed5dbea82eb3467667a45de6742f76ddb"
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
