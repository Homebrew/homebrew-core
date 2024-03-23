class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.16.0",
      revision: "488901740dde3966697135ad094c3930fe14bb1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7efdaadfe2d7b1eaa6c94edaccd18ba80d815dac572f32be5e47314e45f5629d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cfbf96faeaf3f0bcc13446f9d01c34703253b2a6958bacf21a390d3a78a5909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e3118817c08b51241df53dd165d30fbb7db46d5ae6a8e04e85db8f51e61a85f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2493261ab9d7216d004b137d5e305399dab62c3d5bce15fa98af2cd97504a04f"
    sha256 cellar: :any_skip_relocation, ventura:        "0040c4659e2f39103ec58d42124ea8a3e93662e4756428c0695ab5ca75512206"
    sha256 cellar: :any_skip_relocation, monterey:       "388f44d3fa7fb7bf7cfbf012b5bc1ac480d0012b39e08dc8a7834ba8b5ff337d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df99f936258c24e5ac11cc2c8338a03b540832fc5ab3ab28683efd5815c59662"
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

    system "go", "build", *std_go_args(ldflags:)

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
