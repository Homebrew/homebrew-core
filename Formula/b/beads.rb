class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "f93efb39e4fe3f9509cde80b842c1a692f82be569b3eceadcb38b6fde90bff9f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3482a9aaa978f62f8db069c23f5517a273f06676bd3ddee0fb819531c24d2d1"
    sha256 cellar: :any,                 arm64_sequoia: "a44f06fe740b31860bb9e2b7612921388753962e3f8964062267440f6c31d680"
    sha256 cellar: :any,                 arm64_sonoma:  "f002e8216b5e53d4b7a38e87dd203f9cabf8cfe11695fb083daf50a5d0bbc39c"
    sha256 cellar: :any,                 sonoma:        "c2565e957f7ce6ee69d5bd094b1db0985db99a4908129ca63af8ddd07340f6ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d58368a795948119e9c6b9369aceaec2af3edd5fdb49beba66cc0873576741e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a7ab626cf106dfb4a7190c7890c535b565c1886600707c8b703ed61e649f7d2"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  # Fix to add self-managing Dolt server for standalone users
  # Issue ref: https://github.com/steveyegge/beads/issues/2050
  patch do
    url "https://github.com/steveyegge/beads/commit/893f6fcdb45125ca5fb308b668f1f4a220574f04.patch?full_index=1"
    sha256 "b6e3dce9d9c0bcf3ccf4ed53a39c448a172b1fa7f27300c484007dcd1ee611ca"
  end

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
      -X main.Commit=#{tap.user}
      -X main.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    shell_output("#{bin}/bd init < /dev/null")
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Beads Database Information", output
    assert_match "Mode: direct", output
  end
end
