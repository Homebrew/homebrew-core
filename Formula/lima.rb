class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.15.1.tar.gz"
  sha256 "1e8790257810b704462a03736ef4bb8a2a3a873b21cceba86afcd6b2b1a8482b"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "324576bcdcda541e9b6499ca2f73a0da281e42a9a983dabfb5c81a4ebb1cd967"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b36e474584bfba5a1867d3a4411359504971a075c9136338c8616ff1e6d2d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d70d7579ec15823bdbfb7da7e963623fc98cb4b240f71c2f4f1a8caf2946dacd"
    sha256 cellar: :any_skip_relocation, ventura:        "37538ecda69b9c3c8274170ef2bd53598ffa47129739fdfd116a41cec7b3c4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "f272d86c85f24e515f77114dd3eb0fdb82d604deee60f124155a932bcaee7446"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e9462e019d5898e42d1d4a3030431aa64d87d5e4c9412c4407d8729e4b29fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9298b3831d803e3dd8d99b3c7b781d8d8ae831b80ab1d6803a8d6e9751fc04"
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
