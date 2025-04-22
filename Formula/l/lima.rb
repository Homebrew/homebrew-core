class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "90f682e96a370c342c3b16deb1858f37ee28ce88e888e1d6b2634ba24228fdbb"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a99cf98dbfdbd0b3ad62f4d84640c5cfcef5242cbaa4b8d043c1d12c41809b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd766f555146d659f9841554a8270e704156b48ae3502c584b0e1f4af076688a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69ef12a79d1a2057073cdb7e659d6f903fc02cb816f49c856e032df853b549fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfabc4017b8412a0d6d69445c2a398a387af58c5b5c232542d07689d00e1c345"
    sha256 cellar: :any_skip_relocation, ventura:       "2f04d37e54c94d413434f5e0ac74f52d7c2714df72f12198e86545b7aa71310d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6385e14aa7c7b095f780d3143121353dd63383cac97f050e0b45e86ea7975ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dee156f0206d0ddb735d4da04a1eeade34799dd9b5e37db32da404a14fb49cf"
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
