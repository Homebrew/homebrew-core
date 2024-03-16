class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "86ecdc2758b6afd55faa06918b7a506108e95fbdfd93aa18a0ef5e7b59b4e7b4"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1f62d01a2012a493cdde3039567bedae4060a3734c563a5c5efc0551e7d14b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a72ed11b8f0f2ae4abd81d9dae701791f9b55d6fd1f743aefac8aff4aa786ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bea3b91b8373c70d6baa115f8f49f543424019362c2f6724cf3c0f8117d6d77"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9748a8dcc19bddeebd008542083260c074689aa530f811b7681899bb569917f"
    sha256 cellar: :any_skip_relocation, ventura:        "2e622cc16d4b946331a75571479ab15604e3dade49a6e67a2d6a8370acb71b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "64335ae23a01ad1ef3d4701f39206586d287cd4c958bdaadb119fa635ee93fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3754561f003249b8706ffe4d7b585c9356b7ca297ab5c3c6a24cea2ef68c850d"
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
