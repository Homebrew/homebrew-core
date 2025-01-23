class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "dd8bb1c6ee536666f093eb13d5831a906ca3eaa9aebc914bdfb006d4b114a949"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316b93c8552667b5e5dc2d2da92cf3bb7599a909fa968dc6dcb3ce5fd3e55d6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3498fa6467bd90c5dbfae64fb0a5689153950bbdf28853031f7903d83300396e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754a8a542ce735d010136e5719075212c4523036b08bfbb67aeb148c6d1824f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b094132c4b98d6861d853433dcaa0ce41ac78bb42f8de646c52fd3d0d860e40d"
    sha256 cellar: :any_skip_relocation, ventura:       "e568ef730b11891f8e074326ed239404464d42bf1bee5c1c887a48dd466eb5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77eeb5879cd7a2491a3d7c61d3902702b97747f491b4fde95d99c95d4198419"
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
