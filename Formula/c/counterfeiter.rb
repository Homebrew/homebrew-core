class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.8.1.tar.gz"
  sha256 "6a939a96a6957aa5866abe6368b798c0ec14574c8aa2ada002311e8895989aa7"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a017ffd8f7d823ab015c3d805e37814a775e480b80fa56e5cd981948d3ba20bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a017ffd8f7d823ab015c3d805e37814a775e480b80fa56e5cd981948d3ba20bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a017ffd8f7d823ab015c3d805e37814a775e480b80fa56e5cd981948d3ba20bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac78e9d85cd584241c58e632e0ef1bdad9f8698b7e8f5029593000db9c31d1b4"
    sha256 cellar: :any_skip_relocation, ventura:        "ac78e9d85cd584241c58e632e0ef1bdad9f8698b7e8f5029593000db9c31d1b4"
    sha256 cellar: :any_skip_relocation, monterey:       "ac78e9d85cd584241c58e632e0ef1bdad9f8698b7e8f5029593000db9c31d1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0592c3d3b5d8def4655c2fa208db90d341dd3f8ade5659f54ebbca88c8ff1d0"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
