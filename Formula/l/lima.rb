class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a3efa067676ca80e780671eade074a5ff8ea080b04563f3cfd07cfc9ca4cbf76"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1128164f9a1edd7ecd87ae08ce8439a0b608453bacaef5d97d96a4d1042eac46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8c7bef54456b35e3b6d995a42b134767bcc6a8df92a1f31750d076f32a7a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2b44abdaaa79819b72ea9b03a0784a107218732d30e388d727358c957253a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d86649aee76af90e7e38ee4f35ce0473e2cf4dbfb10abb1bdeca6e553b8c63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c73facd7fa86fe00cf316dcbfce1cbced61e5362c998b2ef269107030be66b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34eaf6247943ad51173b07375e1bd16a0c76b8c0971cf6a323c0e31cc5be3e32"
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
    generate_completions_from_executable(bin/"limactl", "completion")
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
