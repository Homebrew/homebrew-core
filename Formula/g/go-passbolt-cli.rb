class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "549dced914c7b6febfacb2fdb223f525621dedb685290e496cd8c168dcf72a46"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "710ef33d28452df58fd1772bea269117d80930f3960a99911f1252a838617992"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710ef33d28452df58fd1772bea269117d80930f3960a99911f1252a838617992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710ef33d28452df58fd1772bea269117d80930f3960a99911f1252a838617992"
    sha256 cellar: :any_skip_relocation, sonoma:        "db4b0ddeb531252cb1eb991eb252b4bbe8a8b412c4600b8b3ab368b615389f5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4049ebe02838aad904b356109d524cad927a7bfa2fc55dc34ed3e43d6eb9b38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0beef5fba01baf994f4fe30ff5fb5483dc59bccdaf1287e38677d00d6c62d74f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", shell_parameter_format: :cobra)
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end
