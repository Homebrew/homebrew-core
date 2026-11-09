class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowsernext.github.io/filebrowserNEXT/"
  url "https://github.com/FilebrowserNext/filebrowserNEXT/archive/refs/tags/v3.0.1-next.tar.gz"
  sha256 "c70c39e9bd43494cd93f912844fa034e1235c36978decab0210986dc8d78738c"
  license "Apache-2.0"
  head "https://github.com/FilebrowserNext/filebrowserNEXT.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fad797c2f580c6ec91b61d5f5c224648c7902c3b7262b96a014f6ae6661f6040"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8789bd5961b8beb37f046a7adb9b17bd273d54f2207ad059cf30f660fc273028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c055be1423a5a17e9877f6cb7d43f0a83adce33761f6e57b319c64020e04fba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "46a7e990c3ea079ca1c181b17dd3c810552a2c08d8a49b465b7899ad9b92541f"
    sha256 cellar: :any_skip_relocation, sonoma:            "19ab0bb605b587c78696d2a59d6d1b9300f65da1392c30b1ef6918458336e4a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "639a8f3c6ab1e304030542e019c80a5d15f7d38fb872af02b10fd96e897a823e"
    sha256 cellar: :any,                 x86_64_linux:      "6977f455d22496075ddc355d6b8dc41cb4c16afcfd938c16953c60432379b138"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
