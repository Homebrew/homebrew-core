class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "90485789d02071106864a3003b62975bc213dcedbcc96e53c07adc4c2a91c38d"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ae2da9e402bd6ba5b64d7f4a00205b5110d1756653ab57bdf9ba36f491e8b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7a16d80d6e814af2487f44886342e7fd080477b209482ff23abaf5e8993dc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3fee62d7e72b489bec9c83313cb98c2520d3391ab1cbec0d1ad0048870b845e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7eb0a95c2af024732f8c9086836129b404098e4ac9e918d8b6985af88cb04a9"
    sha256 cellar: :any_skip_relocation, ventura:        "ef5d07ca44630f4d3a3f42b1971d994bde5e14a00757d151d4f22f3181e7b2bc"
    sha256 cellar: :any_skip_relocation, monterey:       "0d0591bd1739a634d4e0468f959b28629fc429c837bcab9362688407f566ee3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9efb37b5f45e66d8d5bd9c31171d82dad402d9c950758349080054091b870c33"
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
