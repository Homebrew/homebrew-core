class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.14.2.tar.gz"
  sha256 "8d6cd72dd1670c6ade1f92ede6dc01ab64cbeec38fbaba617d9aa93f59ca1ae1"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b6a2b724940d4a501b2fd12cef294966fb9fcef39b8b71cd9b5204af1e3d9f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a51c8d842a56553c0bd0ee535804fa47c3e3939805186fc585811c4f745fd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fec95d1af61748820dc8253db8be2d785199e4e657de83dbbe095a455688ed0"
    sha256 cellar: :any_skip_relocation, ventura:        "e903ddc7771039302668c6773eb4789bfe25525dd13a89a81126d41789245e27"
    sha256 cellar: :any_skip_relocation, monterey:       "4f4c41dfbc3bb566297b09b9018aff593fa2339caafd9422799f309aef95f24a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d9c973e6ab47541267f501e3806d5b3f27b4ad410cafaae9ea2295960b23ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09bbb6cfd33cade28d08add4e3e49e41a7d90c6a16065c2824f8e58bcae2b30d"
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
