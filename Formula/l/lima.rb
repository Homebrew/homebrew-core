class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "cdba3804df7d8c00a2af674a3fe0b24c19673a0e846e5f75ac9badf227ce52f5"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dfb60d4c7d0c6721eee679ab188d8b502ad61d1063c9914b830b66ce795b4a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf9f97484c9dc02cfd4a0a9dacf6c890652f2b2fb324410db0ca0acaacd326dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77c93945bf5f3eb6d0397c1753adf14d2915181a188b79527cf2f60009fe7377"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8ec6266703cc3f481b8593416d0c044bd1b5b20a5286d5953dd2b4b9fdeb7f"
    sha256 cellar: :any,                 arm64_linux:   "14f3457f4425cd0058af128dc69da51f976a5d29deadbdc10c2f3ffb42e31abe"
    sha256 cellar: :any,                 x86_64_linux:  "759a33791896c5c45f6634aa4b15bbb9a5382eb2673cabe2567d1448ffe5541b"
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
