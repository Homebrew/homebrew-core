class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.680.tar.gz"
  sha256 "ae797d794f1441afe8ab088e50301a92c96e5caf5d3bd1818a7f6e74a4bb5a4d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22ad37bebb5f50fe8f91256018b1b442d57de9fdcdb03cad7284128fbf19942b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676b85f81aa4ba1469898a66373a27d87df226fd7ab08501e7b1f1f3915133c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fea1216880d97ae59b8d04a791d128a78bb8f26fe0971192f27c0d03a59cdb7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "375f2dec8ba52ee1aa6edfdf606b30c54c3adccd8047e47454eda8cfd82448a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67474a437a1676abc911a163ad452731954332970bf79801c729b9fb565c75bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e097dcd88899ffa1705883b1308eb12930129833b040639fdbf8d13001c178"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
