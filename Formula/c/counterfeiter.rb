class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.12.1.tar.gz"
  sha256 "b01c714fd789e389f9361a7f1f07acccb02614e702bd7af5d5157ddd4519fc48"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "154c4883d92894bcf466aca58f269205ed00a29fe03fc499b495269b48c3d183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "154c4883d92894bcf466aca58f269205ed00a29fe03fc499b495269b48c3d183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "154c4883d92894bcf466aca58f269205ed00a29fe03fc499b495269b48c3d183"
    sha256 cellar: :any_skip_relocation, sonoma:        "23262c42e7a2e3cb68f64f4606fd917eb9b3dd9fb0ea1a21f45be281f298eb40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b0331607eff5c4d08812a642c174c73ae871bbf45578f3ebb7b7abb831e37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aae1b51283be191090ee819b7b03c927e2acf8f4bad6ecfea00ff7f8e126dd7"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_path_exists testpath/"osshim"
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
