class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "676cd6bd039c25fe649a35ea86977706c0818442624da87c7f4285257cc7aa12"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69aa13c4e83fef7dbee43cdcc2cb42bc0d530af93d45d2b326bf085c9d811e95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "649f464d9d76525c2c90a5b8a16e0b284bc840ea7e1a1a049ad588c8bf6e94ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ff81fb32aab580b49f2e9b08d515295d885635b3089d65d0d33f07dd5196a70"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b61ffca2caeca97a77abe8913e8e185dcde8c78df7130fbf5247cfde668a638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b315607c1a17e39775f320994f2daab2ba7e194da11f1b1bdc306dc45be1262c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed178b7361e082c499c440b9c3f66868ec2d44341fb2030942da78eaf7bde54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
