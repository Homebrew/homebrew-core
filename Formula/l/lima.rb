class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "fc21295f78d717efc921f8f6d1ec22f64da82bfe685d0d2d505aee76c53da1ff"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7e9eb7131cad0f52a28e731f761ec07e8c1253677b5cd93a4eed7a51a1409d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be8e2b92961eca2f862f1a994dbef367e86d36705a705ebfa16d21c7f1366c35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4bd7ae7921fbd9878b421ac8234e69ce04bbb73db04152c87a17514736dd032"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1ad1c6e49a36e4a983070bec6c329b8dfd53713d301b5a44fe3781f9db1dba"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2e69a572afa3a3cf895643ede988c87dc0622dae4aebc539d5564d820845841"
    sha256 cellar: :any_skip_relocation, ventura:        "08d6dc709086c26b7082ceb2303c96f4141ef27244e997e1944235d242fc57fd"
    sha256 cellar: :any_skip_relocation, monterey:       "ca6ccd5bb69fe6616c813562e8cfe73f3009f78e83ae67ced098305442450609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "741e9c7345e15f04b8feaf5034868f00fc3ff792226c485ab2e7679803411e0c"
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
