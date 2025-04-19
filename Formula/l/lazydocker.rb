class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "f54197d333a28e658d2eb4d9b22461ae73721ec9e4106ba23ed177fc530c21f4"
  license "MIT"
  head "https://github.com/jesseduffield/lazydocker.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56e3e9243fcce363bcc3af848e66be911f855a1b00c52cfdfe6dce245a7c60e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56e3e9243fcce363bcc3af848e66be911f855a1b00c52cfdfe6dce245a7c60e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d56e3e9243fcce363bcc3af848e66be911f855a1b00c52cfdfe6dce245a7c60e"
    sha256 cellar: :any_skip_relocation, sonoma:        "223526b606bffcc7ff56767b65e135fdc82b6df8575a8c21897a7ec4608404c8"
    sha256 cellar: :any_skip_relocation, ventura:       "223526b606bffcc7ff56767b65e135fdc82b6df8575a8c21897a7ec4608404c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43b3ee2215c9e3f64e30c9a06037fbac3cf78c58e9cb150ff1e3e42f657a67bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
