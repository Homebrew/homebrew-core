class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  url "https://gitlab.com/shackra/goimapnotify/-/archive/2.6.0/goimapnotify-2.6.0.tar.bz2"
  sha256 "9d51636d8f546d3fd2c85284800d5491b0919eecdb110092431e7ca15b771516"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/shackra/goimapnotify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a41d5ff5bfe6145f6d21c3b69a84726c473314b0182a2c24984ebc12fa4fdc54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a41d5ff5bfe6145f6d21c3b69a84726c473314b0182a2c24984ebc12fa4fdc54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a41d5ff5bfe6145f6d21c3b69a84726c473314b0182a2c24984ebc12fa4fdc54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bdbcecc8c2c95f79bc26977997c9531ea23c2d97b5b9d5f4f4ab9944bde2586f"
    sha256 cellar: :any,                 x86_64_linux:      "326155ff39c82b694c49921ec87f8c1b766eddf1104388d9072a4be2a1dab51d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gittag=#{version}"), "./cmd/goimapnotify"
  end

  service do
    run [opt_bin/"goimapnotify"]
    keep_alive true
    log_path var/"log/goimapnotify.log"
    error_log_path var/"log/goimapnotify.log"
  end

  test do
    (testpath/"config.yml").write <<~YAML
      configurations:
        - username: test@example.com
    YAML

    output = shell_output("#{bin}/goimapnotify -conf #{testpath}/config.yml 2>&1", 1)
    assert_match "tag #{version}", output
    assert_match "empty or have invalid configuration format", output
  end
end
