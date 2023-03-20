class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.15.0.tar.gz"
  sha256 "ab96a893a9212155caf1b8675d6649b479d43205b3c366e6ed30b299b49b7c87"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c677021e4746af72e60b7367aa3e40f94557f615fe2e5ae46421c5ee61dd2c5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9af8abe0cc3c8a1ecf4244637749f27aac29248816e80b1a73470c16e177234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c0cfe019e18f6804e78543e923e437603b54f10a9b4699bade2a61532b03ff2"
    sha256 cellar: :any_skip_relocation, ventura:        "f390659815f1d4aa9f1e3b5ecf8d0979b4e10a5d3503447d34fbc41383daa844"
    sha256 cellar: :any_skip_relocation, monterey:       "b75208160ba629038a1664022f28d33555b2f6fc00ceee37fe3c32403445eeaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e3852c344d501b85194efc3fd6e95651544835a39cdf3ad96c9fb8c9449a282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90216f6a5cefe0a7790665809137da95c74a9d040c038bb157035a365763cf51"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
  end

  test do
    info = JSON.parse shell_output("#{bin}/limactl info")
    # Verify that the VM drivers are compiled in
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if MacOS.version >= :ventura
    # Verify that the template files are installed
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end
