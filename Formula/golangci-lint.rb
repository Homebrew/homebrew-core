class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci.com"
  url "https://github.com/golangci/golangci-lint.git",
    :tag      => "v1.29.0",
    :revision => "6a689074bf17fd4ae1db779a74dba821a162b6c8"
  license "GPL-3.0"

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short=7", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
      -X main.date=#{Time.now.utc.rfc3339}
    ].join(" ")

    system "go", "build", "-trimpath", "-ldflags", ldflags, "-o", "golangci-lint", "./cmd/golangci-lint"

    bin.install "golangci-lint"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"golangci-lint").write output

    prefix.install_metafiles
  end

  test do
    system "#{bin}/golangci-lint", "--version"
  end
end
