class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "54918ad12f6c69ac3d8a5f1e500ddeeeb9488bd9821bc6d8cf8fc49759be96d8"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f3aada75e46c5829d34e29a40435db44a5a98e8a1d6306b8c298fddd61e74f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ec11c70617993f11f690506c1d07c7fd34cc5cbffec345386ae1c1dd8fd993a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "147a3a536f0aa2301b22fc71cd680cb1ad00e1b7b48352b245f8adfe759d89e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ff73277d3f7458b2fe906857137a0cb1a2084551522e52fa7e0ef6abf1acddc"
    sha256 cellar: :any_skip_relocation, ventura:        "d57e33c62b55de8a0d21dbec1b0815053a216e97fdc1d3c97f667002b6c01b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "18137e9a86657c9719dcd3757e60d3188f607997104a3af5eb88c147c901c7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b630c58014561f993980d3bb3c03f53b30d0c1f64d2110061b222dd58b6d12c4"
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
