class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "06e52a953b2e46044c70bc41421554c5d006370b1a25905b752d02eb0b337f0d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8fa08df32fb88a784f1487aeb7221e3cbebb9c4fcebfb37bdab4e6f0501b02a"
    sha256 cellar: :any,                 arm64_sequoia: "6701bd6dd45af074ab1fd2fa679819daf717636d9c49542502b0f3e1a61595bd"
    sha256 cellar: :any,                 arm64_sonoma:  "adc276608d86df0e2872a65588a91be2185e72ee54233ab314b3799258ec7398"
    sha256 cellar: :any,                 sonoma:        "873801f3e80106f3a8533705ea4b818dc43c71fd56a0f808f02f0b668bd099c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e1ac41bcb03058ceac7373fb1e6a4b384164c8b99449ba3e98c13fe780a5f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35357e5e576dbbb9144bb87a325d15c7ed01f067d22c8d77e0d22ae23653eccc"
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
