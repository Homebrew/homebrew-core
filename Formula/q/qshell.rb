class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "f0b9e9bec2e9f07b144d7fd660a60d419da07ae4c1882a7a6f7c5a9a7f969002"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e0895a04e25a5389bf6581c15655c9c494752ffd0633ec34ed5f387343284f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ff629197d9611911b20554fc6d8facdf740ec4349509e77eaf8b4b7fb99af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fafa0f83b863d64973e22fe5a4e16567874938e51024be431ffc64701f740f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4ca827c917019ca343b5a50eb83023ce09ddd04967a9296e4a5fd9f303e0c4"
    sha256 cellar: :any_skip_relocation, ventura:       "e445640b9b3068b67019755a83247d9650527bdf6282e2535b93d6ff612ffa54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5149b877deb02d7f1ac5559d7d6b98c247208ffc30d3b84c14228261945caa90"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./main"
    generate_completions_from_executable(bin/"qshell", "completion")
  end

  test do
    output = shell_output "#{bin}/qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}/qshell b64encode abc"
    assert_match "YWJj", output2
  end
end
