class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "3f6dd39922eb42ff6aa497c28b7573775864a38554002719fdbf64a05033f87e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da8b5130a2e1325f6eac4028f6eef7a2ceacd9baa3d7dbede73de9f762882bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cbb5d00303d1cbb1768398f12b89e5b96162fe2ca71d7e76321bbed6cc85bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1798dafe2d590e5fd4bc7e5c8b80aecf86b9f07c9029414eb6f8643c7db09add"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d0f81a84d8390cabe6d4750d9dbd3c6d66e9ef6445a2290fc1889090c83a039"
    sha256 cellar: :any,                 arm64_linux:   "6607747ec37e9d2981a95bcff3d7c28567c4530fa2499c0b4678833397f7b928"
    sha256 cellar: :any,                 x86_64_linux:  "b57294b4216cb4c7fdc12cc4bfd36d8dcc62b3f99c9eb930c9a511cf16142a8e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

  def install
    # make (default):              build everything
    # make native:                 build core + native guest agent
    # make additional-guestagents: build non-native guest agents
    if build.head?
      system "make", "native"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "native", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    libexec.install Dir["_output/libexec/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", shell_parameter_format: :cobra)
  end

  def caveats
    # since lima 1.1
    <<~EOS
      The guest agents for non-native architectures are now provided in a separate formula:
        brew install lima-additional-guestagents
    EOS
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
