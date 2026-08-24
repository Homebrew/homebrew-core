class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.23.tar.gz"
  sha256 "18020983f6a4e43d679738738c3f95c52a333a282144046ec152491f2341a152"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8789bd5961b8beb37f046a7adb9b17bd273d54f2207ad059cf30f660fc273028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c055be1423a5a17e9877f6cb7d43f0a83adce33761f6e57b319c64020e04fba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a7e990c3ea079ca1c181b17dd3c810552a2c08d8a49b465b7899ad9b92541f"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ab0bb605b587c78696d2a59d6d1b9300f65da1392c30b1ef6918458336e4a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "639a8f3c6ab1e304030542e019c80a5d15f7d38fb872af02b10fd96e897a823e"
    sha256 cellar: :any,                 x86_64_linux:  "6977f455d22496075ddc355d6b8dc41cb4c16afcfd938c16953c60432379b138"
  end

  depends_on "go" => :build

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
