class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.13.0",
      revision: "7f69502bddd6650e7cb7a132291bc54920e58988"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a4937cc83090c1da42d3536522175285ed5d5628a14f1f4509aea94b77d1004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbbc42746f2393ca62fdb0c7e5b8545c01a5987d5de61599289cba0fda94c18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1242a67ef3aeeeccc3cfbbc1580960cb62a7fdb158c33c8286a60d5d6e2841d"
    sha256 cellar: :any_skip_relocation, ventura:        "8c048442387c3568435eb7301a916a352d0eb93289b0273ab7762741e1ad0d5d"
    sha256 cellar: :any_skip_relocation, monterey:       "cf58141d72eb59edfedb2a98a3290c8a0dd61cf5a3364a37913d9bc31efc044f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0328539b841e86c27ff00739a6865dd4ee0d84d0e5aa6795672e390cd01d558b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd69cebba9c1a9e53a42f029cdb08e3b4efe6e0abb6ed13ca00bc5fe6a1a75f"
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
