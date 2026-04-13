class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.65.1.tar.gz"
  sha256 "1d10184b57b3fa51ae71e6f444235a0fdf883fa132ca749282c9bcc29534b249"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b54539b3f4be771dd1ecae5542e82cb2dde0c2307457a373ae3b770a2799430"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b54539b3f4be771dd1ecae5542e82cb2dde0c2307457a373ae3b770a2799430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b54539b3f4be771dd1ecae5542e82cb2dde0c2307457a373ae3b770a2799430"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b1dfd98530ce189874ef962c3eb492c11bd13655a2dc1833164a6ba2675e48f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a5986ce544e302ca52cfb9eddf2a6267d41efd61d7d829bf48769ccabe3daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbfcf242c29357e2d89b6c98677502499821965a0e5855d1d9fd599e10123f0e"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = %W[
      -s -w
      -X main.BuildTimestamp=#{time.iso8601}
      -X main.airVersion=v#{version}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v 2>&1")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end
