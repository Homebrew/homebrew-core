class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.15.0.tar.gz"
  sha256 "ab96a893a9212155caf1b8675d6649b479d43205b3c366e6ed30b299b49b7c87"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce5088e10ef27bc559052f93dd5e38df9592b57bf69a614d351f0b46f9b12587"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1390f3133d929dd5b24c0b1449aec981e55eaadfcb97a56056f800fdd763629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01fca548e0d566e3fce5ce93ae324041eec12f2b8ce3bb97982bd455125a8611"
    sha256 cellar: :any_skip_relocation, ventura:        "c5f2f4632637a223301c66ee55a698507f2efe390a662adcb6a74f6c8024c5d2"
    sha256 cellar: :any_skip_relocation, monterey:       "ee23098ac72c5c09b4af8c972c4e3f82c4217ad3034a0aabdb0cca2803f26830"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d24b04f2a38953d18559fda7d2852cc38e7a8966cf1b903007a4bfa8ff79d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873980f58ab7b7a9c5f4b59ae87fb8ba84e85356343bb4e2af58ea1b480b4b5b"
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
