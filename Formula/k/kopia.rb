class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.14.1",
      revision: "1f70992d2ebe7e44c21e113375678e7372ca00bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f24dee26f7efae39a2c46efd17c33ff8100df739c53f978f216af0edef068327"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "411bc644a85c1a21468960fdc74fcb5154e5711b073de1d080ce1cd16c0752d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd36423b92b5211e80cf27be7a69288100d300402ba89b596ce08bf9537ef890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5844cfaacc337b1a5594bbef5e55696edab5990886b1b169c754e34521e441f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2f432660f7ae5b6cd49003e779dac987861a26621d9d410539dfa477e408e44"
    sha256 cellar: :any_skip_relocation, ventura:        "3da13b0bd98dd2083bd7f30827f46179aa8502be201614e16477590819641180"
    sha256 cellar: :any_skip_relocation, monterey:       "efb7e4b3804ec8dbb6f1f119e33274ac5e5c52e96673d2024dbc10f7ea4ad764"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf6a384330b3660f91dd554c5df6c6af586c036585665894c87cb48622c028a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "221b6b8dce59d258ecaa9006a242882182d3cc72edd7e86c7832c92712c919c4"
  end

  depends_on "go" => :build

  def install
    # removed github.com/kopia/kopia/repo.BuildGitHubRepo to disable
    # update notifications
    ldflags = %W[
      -s -w
      -X github.com/kopia/kopia/repo.BuildInfo=#{Utils.git_head}
      -X github.com/kopia/kopia/repo.BuildVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kopia", shells:                 [:bash, :zsh],
                                                      shell_parameter_format: "--completion-script-")

    output = Utils.safe_popen_read(bin/"kopia", "--help-man")
    (man1/"kopia.1").write output
  end

  test do
    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    output = shell_output("#{bin}/kopia --version").strip

    # verify version output, note we're unable to verify the git hash in tests
    assert_match(%r{#{version} build: .* from:}, output)

    system "#{bin}/kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_predicate testpath/"repo/kopia.repository.f", :exist?
    system "#{bin}/kopia", "snapshot", "create", testpath/"testdir"
    system "#{bin}/kopia", "snapshot", "list"
    system "#{bin}/kopia", "repository", "disconnect"
  end
end
