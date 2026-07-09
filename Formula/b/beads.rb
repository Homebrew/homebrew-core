class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://github.com/gastownhall/beads/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b38263c14125f5c05b6b70af06d1d3f152a7570e625518746ff8d783d11b4eac"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b8eb8814f989e37363fbeefe3d1c1f4448affdeb2c2c4202e5dcacf1f9e1378b"
    sha256 cellar: :any, arm64_sequoia: "6d1018b6c8a6ec8ef8fb23a77136b1b71662cedde48fff3cd3f10ca2fe8ca701"
    sha256 cellar: :any, arm64_sonoma:  "76a9b284475307164aaa3ac6d10b15c1d2e87d7d54e39044d9ac2d4d415b3a57"
    sha256 cellar: :any, sonoma:        "5ef5bc6fb50400a61fc331f56152c8d321ae0e3a9d5b48ee1c6a9c1f1ba38918"
    sha256 cellar: :any, arm64_linux:   "3ad5fc222d6f07f783722a780f18329089027cf7dee1b82dd82d74277848ec69"
    sha256 cellar: :any, x86_64_linux:  "2d6c00d0e20f2a6d852c2f14a80d08ae9ccf6d95902496e566397deafe1ce8a0"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@78"

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system bin/"bd", "init", "--prefix", "homebrew-beads", "--non-interactive", "--stealth"
    system bin/"bd", "setup", "claude"
    assert_path_exists testpath/"CLAUDE.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end
