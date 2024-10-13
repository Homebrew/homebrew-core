class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "509b16ca713de02f8fcdc7b33d97e7e18b687bb99634dde076be38297d4b401b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "da882bae38256fa273b80071e504340c008df9fce87ddd80fb9a6f00b20c00bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52048ab65b5ae408a1e86fc546f7b32b3361324c7a5e46b0ebedfa15e436ef20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c7047a7480c33b49071ae0ea40eac7721c8754851e1059e179e200c4f602597"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3204c0dfb5f1e3140be3b222f3a72d86d9855a7cf5ad797e5c7ad538a2ef4f85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67390665666b6b7ffc8a8bc38640f584aeff4826528718f7e4d84ad1498ad8f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a82a889421d6b4894d9ce4a34d0c91639b665c98c9fad01f2baa7c94eb662db"
    sha256 cellar: :any_skip_relocation, ventura:        "c98a704e273a22b15c897943443da3630ee65edac54f508a78c6e584c204d6ca"
    sha256 cellar: :any_skip_relocation, monterey:       "daa974570a28e9f7fc6b81f9c69fb7be4224c4b8a87e4f03a2a5ea0afe7bf399"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f0f5a28c757baab0ca97418ce632adb77198ef0b354ebac8872dadaeebec2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "328590ad8d6ae42255b8b2647517760a4694d97d35685ff60e662f670835e62b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gobuster", "completion")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output(bin/"gobuster version")
  end
end
