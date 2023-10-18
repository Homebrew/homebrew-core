class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.18.0.tar.gz"
  sha256 "f133c6fb3e4a382441d30bd8fc87581649cdd22dfddd0c024f11bf0367a9eac3"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f95090e2360ab3680ed20648ca3888225efe587ba9229c648f1e63e219967687"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6fab71646bd647da8b1fbe93ca93cb5c39ce550bcdec4c1961a6a2227478769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70413385beb65071461606ba214600f44182bacf40c027bef154592a3ebc974f"
    sha256 cellar: :any_skip_relocation, sonoma:         "94af9be3bbcd2bb0ebc6646226aa180165df96a0e6dc8b837b6ed4beb79dd04c"
    sha256 cellar: :any_skip_relocation, ventura:        "3bbf83268ac0615a9012e5f9f939d1362aea1c85737b7839a0544dc201cd41cf"
    sha256 cellar: :any_skip_relocation, monterey:       "7f313697af14437adebf45b0e42e9a94485fe24cbab0c8f56ec6410c99dbcf70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c77a7b5821db611f593056a0b211dd4fa615eb09036498b59fa98d95e67bfe5"
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
