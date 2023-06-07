class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.16.0.tar.gz"
  sha256 "deb23bd5d913790943dfa4cee8a6d50629e031750da2a84006736e13240e3977"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8fc0d86b84683fb635bc4bb22ce6936b31c6b2aa02e495aa040f55dee8fa14c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44457c95dc63db38a43632dee5aebce82cf87515ae95a348c5e34dc90597f966"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f194d023f59d395098f8c28b9e9f023e7edb697275888c5fb1b80af58ae205cb"
    sha256 cellar: :any_skip_relocation, ventura:        "7b75ae191db7e4169acbf32695ccf71c12e99a2e54bf26bd4304f9614d3f7338"
    sha256 cellar: :any_skip_relocation, monterey:       "03a5bead3da88bfd4694c30b0e81abbbb16a147851f8458cadb9d5543ac74571"
    sha256 cellar: :any_skip_relocation, big_sur:        "42c8817651a346521c2b5d0885e0d89ce0de605abd22087785ac892f1e0fee67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b420b9a8a944646a7be54dff98f32cadb71322711afb2af9afe73ba2477e465b"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "all"

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
